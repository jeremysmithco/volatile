require "active_operator"

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  include ActiveOperator::Model
end
