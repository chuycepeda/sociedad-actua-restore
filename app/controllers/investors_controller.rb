class InvestorsController < ApplicationController
  before_action :investor_params, only: :create
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_investor, only: [:show, :edit, :update, :destroy , :send_message]

  def index
    @investors = Investor.all
  end

  def show
    authorize @investor
     @organizations=Organization.where('id in (?)',@investor.organization)
    if current_user.present? && current_user.profile_type == "Organization" 
      @projects=Project.where("organization_id = (?)",current_user.profile_id)
    end
    render :layout => "profiles", projects: @projects
  end

  def send_message ()
    if current_user.collaborator?
      UserMailer.contact_email({ "email" => params["email"], "name" => params["name"],"projects" => params["projects"],"causes" => params["causes"], "comments" => params["comments"], "org_name" => Collaborator.where("id = (?)", current_user.profile_id ).first["name"], "org_email" => Collaborator.where("id = (?)", current_user.profile_id ).first["email"] }).deliver
      authorize @organization
      redirect_to @organization , notice: "Correo enviado"
    end
    if current_user.organization?
      UserMailer.contact_email({ "email" => params["email"], "name" => params["name"],"projects" => params["projects"],"causes" => params["causes"], "comments" => params["comments"], "org_name" => Organization.where("id = (?)", current_user.profile_id ).first["name"], "org_email" => Organization.where("id = (?)", current_user.profile_id ).first["email"] }).deliver
      authorize @investor
      redirect_to @investor , notice: "Correo enviado"
    end
    if current_user.investor?
      UserMailer.contact_email({ "email" => params["email"], "name" => params["name"],"projects" => params["projects"],"causes" => params["causes"], "comments" => params["comments"], "org_name" => Investor.where("id = (?)", current_user.profile_id ).first["name"], "org_email" => Investor.where("id = (?)", current_user.profile_id ).first["email"] }).deliver
      authorize @investor
      redirect_to @investor , notice: "Correo enviado"
    end
  end
  def login()
     
  end
  def new
   @organizations=Organization.all
  end
  def edit
    @organizations=Organization.all
    authorize @investor
  end

  def update
    authorize @investor
    respond_to do |format|
      if @investor.update(investor_params)
        format.html { redirect_to @investor, notice: I18n.t('investor.notices.updated') }
        format.json { render :show, status: :ok, location: @investor }
      else
        format.html { render :edit }
        format.json { render json: @investor.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def investor_params
    params.require(:investor).permit(:investment_type,:money,:voluntering,:specie,:service,:name, :type_investor,
                                    :telephone, :email, :address, :zipcode, :city,
                                     :amount, :constitution, :expense_type,
                                    :neighborhood, :site_url, :facebook_url, :blog_url,
                                    :twitter_url,:youtube_url,:instagram_url,:contact_name,:legal_time,:other_causes,:logo,organization: [],
                                    causes_supported: [])
  end

  def set_investor
     @investor = Investor.find(params[:id])
  end
end