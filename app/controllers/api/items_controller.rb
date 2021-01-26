# frozen_string_literal: true

module Api
  # ItemsController
  class ItemsController < Api::ApplicationController
    def index
      @items = Item.all

      render json: @items.to_json
    end

    def show
      @item = Item.find(params[:id])

      render json: @item.to_json
    end

    def create
      @item = Item.new(item_params)

      if @item.save
        render json: @item.to_json, status: :created
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def update
      @item = Item.find(params[:id])

      if @item.update(item_params)
        render json: @item.to_json, status: :ok
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def destroy
      if @item.destroy
        render json: { success: true }, status: :ok
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    private

    def item_params
      params.require(:item).permit(:img_url, :title, :year, :stars)
    end
  end
end
