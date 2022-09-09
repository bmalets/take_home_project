# frozen_string_literal: true

class ItemSerializer
  include Alba::Resource

  root_key :item

  attributes :id

  attribute :checked do |resource|
    resource.disputed?
  end

  attribute :next_status do |resource|
    resource.status.capitalize
  end
end
