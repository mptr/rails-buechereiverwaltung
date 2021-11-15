class PublishersController < ApplicationController
  before_action :set_publisher, only: %i[ show edit update destroy ]
  before_action :validate_user_session, only: %i[ edit update destroy ]

  # GET /publishers or /publishers.json
  def index
    case params[:filter]
    when 'no_books'
      @filter_name = "ohne Bücher"
    end
    @publishers = Publisher.custom_select(params[:filter])
  end

  # GET /publishers/1 or /publishers/1.json
  def show
  end

  # GET /publishers/new
  def new
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit
  end

  # POST /publishers or /publishers.json
  def create
    @publisher = Publisher.new(publisher_params)

    @publisher.errors.add(:base, "Diese Aktion ist nicht erlaubt!") unless user_signed_in?

    respond_to do |format|
      if user_signed_in? and @publisher.save
        format.html { redirect_to @publisher, notice: "Verlag wurde erfolgreich erzeugt." }
        format.json { render :show, status: :created, location: @publisher }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publishers/1 or /publishers/1.json
  def update
    respond_to do |format|
      if user_signed_in? and @publisher.update(publisher_params)
        format.html { redirect_to @publisher, notice: "Verlag wurde erfolgreich aktualisiert." }
        format.json { render :show, status: :ok, location: @publisher }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publishers/1 or /publishers/1.json
  def destroy
    if user_signed_in?
      @publisher.destroy
      respond_to do |format|
        format.html { redirect_to publishers_url, notice: "Verlag wurde erfolgreich gelöscht." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publisher
      @publisher = Publisher.find(params[:id])
    end

    # validate user session but let admin pass
    def validate_user_session
      if !user_signed_in? or !current_user.admin?
        @publisher.errors.add(:base, "Diese Aktion ist nicht erlaubt!")
        respond_to do |format|
          format.html { render :show, status: :unprocessable_entity }
          format.json { render json: @publisher.errors, status: :unprocessable_entity }
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def publisher_params
      params.require(:publisher).permit(:name, :address)
    end
end
