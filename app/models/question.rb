class Question < ApplicationRecord
  belongs_to :subject
  serialize :options, Array
end
