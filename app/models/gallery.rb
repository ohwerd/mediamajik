class Gallery < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_and_belongs_to_many :images
	has_many :effects

end
