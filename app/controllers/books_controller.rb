class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :validate_user_session, only: %i[ edit update destroy ]

  # GET /books or /books.json
  def index
    case params[:filter]
    when 'no_author'
      @filter_name = "ohne Autoren"
    when 'no_stock'
      @filter_name = "ohne Bestand"
    end
    @books = Book.custom_select(params[:filter])
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    @author = Author.find(book_params[:author_ids].reject { |a| a.empty? })

    @book.errors.add(:base, "Diese Aktion ist nicht erlaubt!") unless user_signed_in?

    respond_to do |format|
      if user_signed_in? and @book.save
        format.html { redirect_to @book, notice: "Buch wurde erfolgreich erzeugt." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if user_signed_in? and @book.update(book_params)
        format.html { redirect_to @book, notice: "Buch wurde erfolgreich aktualisiert." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    if user_signed_in?
      @book.destroy
      respond_to do |format|
        format.html { redirect_to books_url, notice: "Buch wurde erfolgreich gelöscht." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end
    
    # validate user session but let admin pass
    def validate_user_session
      if !user_signed_in? or !current_user.admin?
        @book.errors.add(:base, "Diese Aktion ist nicht erlaubt!")
        respond_to do |format|
          format.html { render :show, status: :unprocessable_entity }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :publisher_id, :pub_year, :edition, :isbn, :author_ids => [])
    end
end
