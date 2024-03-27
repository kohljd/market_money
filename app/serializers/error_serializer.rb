class ErrorSerializer
  def self.format_error(exception_error)
    {
      errors: [
        {
          detail: exception_error
        }
      ]
    }
  end
end