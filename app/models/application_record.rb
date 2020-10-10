class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include ErrorsFormat

  def formated_errors
    fill_model_errors(self )
  end
end
