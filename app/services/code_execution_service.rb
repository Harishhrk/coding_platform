require 'open3'

class CodeExecutionService
  def initialize(code, language = 'python')
    @code = code
    @language = language
  end

  def execute(problem)
    Rails.logger.debug "Executing code with language: #{@language}"
    
    case @language
    when 'python'
      execute_python(problem)
    else
      raise "Unsupported language: #{@language}"
    end
  end

  private

  def execute_python(problem)
    file_path = Rails.root.join('tmp', "code_#{SecureRandom.hex(10)}.py")
    File.write(file_path, @code)
    Rails.logger.debug "file_path: #{file_path}"
    
    results = []

    problem.test_cases.each do |test_case|
      # Write the test case input to a temporary file
      input_file_path = Rails.root.join('tmp', "input_#{SecureRandom.hex(10)}.txt")
      File.write(input_file_path, test_case.input)
      
      # Execute the code with the test case input
      stdout, stderr, status = Open3.capture3("python #{file_path} < #{input_file_path}")
      File.delete(input_file_path)
      
      # Compare output with expected output
      result = {
        input: test_case.input,
        expected_output: test_case.expected_output,
        output: stdout.strip,
        success: stdout.strip == test_case.expected_output
      }
      
      results << result

      # Log detailed execution info
      Rails.logger.debug "stdout: #{stdout.strip}"
      Rails.logger.debug "stderr: #{stderr.strip}"
      Rails.logger.debug "status: #{status.exitstatus}"
    end

    File.delete(file_path)

    {
      success: results.all? { |result| result[:success] },
      results: results
    }
  rescue => e
    { success: false, output: "Execution error: #{e.message}" }
  end
end
