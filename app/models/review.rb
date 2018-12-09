class Review < ApplicationRecord
  belongs_to :craft
  belongs_to :reservation
  belongs_to :guest
  belongs_to :host
end
