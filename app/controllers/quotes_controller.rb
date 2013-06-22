class QuotesController < ApplicationController
  before_filter :require_login, except: [:index, :show, :language]

  def index
    @quotes = Quote.in(current_user_languages).recent.page(params[:page])
      .includes(:photos, :user, :votes)
  end

  def show
    @quote = Quote.find(params[:id])
  end

  def new
    @quote = current_user.quotes.new
    @quote.photos.build
  end

  def create
    @quote = current_user.quotes.new(params[:quote])
    if @quote.save
      redirect_to @quote, notice: 'Thanks for sharing!'
    else
      render 'new'
    end
  end

  def edit
    @quote = current_user.quotes.find(params[:id])
    @quote.photos.build unless @quote.photos.exists?
  end

  def update
    @quote = current_user.quotes.find(params[:id])

    if @quote.update_attributes(params[:quote])
      redirect_to @quote, notice: 'updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @quote = current_user.quotes.find(params[:id])

    if @quote.destroy
      redirect_to root_url, notice: 'destroyed.'
    end
  end

  def language
    @quotes = Quote.in(params[:language]).recent.page(params[:page])
      .includes(:photos, :user, :votes)
  end
end
