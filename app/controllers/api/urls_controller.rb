# frozen_string_literal: true

module Api
  # UrlsController
  class UrlsController < Api::ApplicationController
    def create
      @url = Url.new(url_params)

      if @url.save
        ProxyCrawlJob.set(wait_until: Time.now.next_week.change(hour: 10)).perform_later([@url])

        render json: @url.to_json, status: :created
      else
        render json: @url.errors, status: :unprocessable_entity
      end
    end

    private

    def url_params
      params.require(:url).permit(:name, :scheduled_at)
    end
  end
end
