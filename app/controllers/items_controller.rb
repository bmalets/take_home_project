# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_item, only: [:update]

  def update
    case item_params[:dispute]
    when true
      @item.mark_as_disputed!
    when false
      @item.undo_mark_as_disputed!
    end

    render json: serialized_item, status: :ok
  end

  private

  def serialized_item
    ItemSerializer.new(@item).serialize
  end

  def item_params
    params.require(:item).permit(:dispute)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
