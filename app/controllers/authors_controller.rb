class AuthorsController < ApplicationController
  before_action :set_author, only: %i[ show edit update destroy ]
  before_action :validate_user_session, only: %i[ edit update destroy ]

  # GET /authors or /authors.json
  def index
    case params[:filter]
    when 'no_books'
      @filter_name = "ohne Buch"
    end
    @authors = Author.custom_select(params[:filter])
  end

  # GET /authors/1 or /authors/1.json
  def show
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors or /authors.json
  def create
      @author = Author.new(author_params)

      @author.errors.add(:base, "Diese Aktion ist nicht erlaubt!") unless user_signed_in?

      respond_to do |format|
        if user_signed_in? and @author.save
          format.html { redirect_to @author, notice: "Autor wurde erfolgreich erstellt." }
          format.json { render :show, status: :created, location: @author }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @author.errors, status: :unprocessable_entity }
        end
    end
  end

  # PATCH/PUT /authors/1 or /authors/1.json
  def update
    respond_to do |format|
      if user_signed_in? and @author.update(author_params)
        format.html { redirect_to @author, notice: "Autor wurde erfolgreich aktualisiert." }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1 or /authors/1.json
  def destroy
    if user_signed_in?
      @author.destroy
      
      Book.all.each do |b|
        if b.authors.empty?
          b.destroy
        end
      end

      respond_to do |format|
        format.html { redirect_to authors_url, notice: "Autor wurde erfolgreich gelöscht." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
      @author.errors.add(:base, "Diese Aktion ist nicht erlaubt!") unless user_signed_in?
    end

    # validate user session but let admin pass
    def validate_user_session
      if !user_signed_in? or !current_user.admin?
        @author.errors.add(:base, "Diese Aktion ist nicht erlaubt!")
        respond_to do |format|
          format.html { render :show, status: :unprocessable_entity }
          format.json { render json: @author.errors, status: :unprocessable_entity }
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def author_params
      params.require(:author).permit(:family_name, :given_name, :affiliation)
    end
end
