class Subject < ApplicationRecord
    has_many :questions, dependent: :destroy
    has_many :results, dependent: :destroy
end
