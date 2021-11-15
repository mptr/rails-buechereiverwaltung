class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :validate_user_session, only: %i[ index show edit update destroy ]

  # GET /users or /users.json
  def index
    case params[:filter]
    when 'has_reservations'
      @filter_name = "mit reservierten Büchern"
    when 'has_lendings'
      @filter_name = "mit ausgeliehenen Büchern"
    when 'has_overdue'
      @filter_name = "mit überfälligen Ausleihen"
    end
    @users = User.custom_select(params[:filter])
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    @user.errors.add(:base, "Diese Aktion ist nicht erlaubt!") unless user_signed_in?

    respond_to do |format|
      if user_signed_in? and @user.save
        format.html { redirect_to @user, notice: "Nutzer wurde erfolgreich erzeugt." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if user_signed_in? and (user_params[:password].blank? ? @user.update_without_password(user_params) : @user.update(user_params))
        format.html { redirect_to @user, notice: "Nutzer wurde erfolgreich aktualisiert." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    respond_to do |format|
      if user_signed_in?
        @user.destroy
        if @user.errors.blank?
          format.html { redirect_to users_url, notice: "Nutzer wurde erfolgreich gelöscht." }
          format.json { head :no_content }
        else
          format.html { render :show, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    # validate user session but let admin pass
    def validate_user_session
      if !user_signed_in? or (params[:id] != current_user.id.to_s and !current_user.admin?)
        respond_to do |format|
          format.html { redirect_to(root_path) }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:family_name, :given_name, :address, :email, :password, :blocked, :remarks)
    end
end
