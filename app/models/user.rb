class User < ActiveRecord::Base
	has_and_belongs_to_many :images
	has_and_belongs_to_many :galleries

end
