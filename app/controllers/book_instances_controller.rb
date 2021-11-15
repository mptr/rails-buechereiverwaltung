class BookInstancesController < ApplicationController
  before_action :set_book_instance, only: %i[ show edit lending update destroy lend reserve return dereserve ]
  before_action :validate_user_session, only: %i[ lending edit update destroy ]

  # GET /book_instances or /book_instances.json
  def index
    case params[:filter]
    when 'lendable'
      @filter_name = "ausleihbar"
    when 'reserved'
      @filter_name = "reserviert"
    when 'lended'
      @filter_name = "geliehen"
    when 'overdue'
      @filter_name = "überfällig"
    when 'reserved_by_current_user'
      @filter_name = "meine reservierten Bücher"
    when 'lended_by_current_user'
      @filter_name = "meine geliehenen Bücher"
    end
    @book_instances = BookInstance.custom_select(params[:filter], current_user)
  end

  # GET /book_instances/1 or /book_instances/1.json
  def show
  end

  # GET /book_instances/new
  def new
    @book_instance = BookInstance.new
  end

  # GET /book_instances/1/edit
  def edit
  end

  # GET /book_instances/1/lending
  def lending
  end

  
  # POST /book_instances/1/lend
  def lend
    if user_signed_in? and (@book_instance.lender.blank? or current_user.admin?)
      @book_instance.update(lended_by_id: current_user.id)
    end
    head 200
  end
  
  # POST /book_instances/1/return
  def return
    if user_signed_in? and (@book_instance.lender&.id == current_user.id or current_user.admin?)
      @book_instance.update(lended_by_id: nil)
    end
    head 200
  end
  
  # POST /book_instances/1/reserve
  def reserve
    if user_signed_in? and (@book_instance.reserver.blank? or current_user.admin?)
      @book_instance.update(reserved_by_id: current_user.id)
    end
    head 200
  end
  
  # POST /book_instances/1/dereserve
  def dereserve
    if user_signed_in? and (@book_instance.reserver&.id == current_user.id or current_user.admin?)
      @book_instance.update(reserved_by_id: nil)
    end
    head 200
  end

  # POST /book_instances or /book_instances.json
  def create
    @book_instance = BookInstance.new(book_instance_params)

    @book_instance.errors.add(:base, "Diese Aktion ist nicht erlaubt!") unless user_signed_in?

    respond_to do |format|
      if user_signed_in? and @book_instance.save
        format.html { redirect_to @book_instance, notice: "Buchexemplar wurde erfolgreich erzeugt." }
        format.json { render :show, status: :created, location: @book_instance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_instances/1 or /book_instances/1.json
  def update
    if user_signed_in? and @book_instance.update(book_instance_params)
      respond_to do |format|
        format.html { redirect_to @book_instance, notice: "Buchexemplar wurde erfolgreich aktualisiert." }
        format.json { render :show, status: :ok, location: @book_instance }
      end
    else
      if request.referer.split('/').last == "edit"
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @book_instance.errors, status: :unprocessable_entity }
        end
      else        
        respond_to do |format|
          format.html { render :lending, status: :unprocessable_entity }
          format.json { render json: @book_instance.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /book_instances/1 or /book_instances/1.json
  def destroy
    if user_signed_in?
        @book_instance.destroy
      respond_to do |format|
        format.html { redirect_to book_instances_url, notice: "Buchexemplar wurde erfolgreich gelöscht." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_instance
      @book_instance = BookInstance.find(params[:id])
    end

    # only let admin pass, regular users must use the one-click-lending and reserving
    def validate_user_session
      if !current_user&.admin?
        @book_instance.errors.add(:base, "Diese Aktion ist nicht erlaubt!")
        respond_to do |format|
          format.html { render :show, status: :unprocessable_entity }
          format.json { render json: @book_instance.errors, status: :unprocessable_entity }
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def book_instance_params
      params.require(:book_instance).permit(:book_id, :shelfmark, :purchased_at, :lended_by_id, :reserved_by_id, :checkout_at, :due_at, :returned_at)
    end
end
