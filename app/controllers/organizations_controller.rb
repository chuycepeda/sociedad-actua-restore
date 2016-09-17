class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update , :send_message]
  before_action :authenticate_user!, except: [:show, :index]
  
  def index
    if params[:type]
      @organizations =Organization.where("type_organization = 'groups'")
    else
      @organizations = Organization.with_projects
    end
  end

  def show
    authorize @organization
    @orgs = @organization.projects
    @orgs = Project.where('id in (?)', @organization)
    @collaborators = Project.where('id in (?)', @organization.supports)
    render :layout => "profiles"
  end

  def send_message ()
    if current_user.collaborator?
      UserMailer.contact_org_email({ "email" => params["email"], "name" => params["name"],"projects" => params["projects"],"causes" => params["causes"], "comments" => params["comments"], "collaborator_name" => Collaborator.where("id = (?)", current_user.profile_id ).first["name"], "collaborator_email" => Collaborator.where("id = (?)", current_user.profile_id ).first["email"] }).deliver
      authorize @organization
      redirect_to @organization , notice: "Correo enviado"
    end
    if current_user.organization?
      UserMailer.contact_org_email({ "email" => params["email"], "name" => params["name"],"projects" => params["projects"],"causes" => params["causes"], "comments" => params["comments"], "collaborator_name" => Organization.where("id = (?)", current_user.profile_id ).first["name"], "collaborator_email" => Organization.where("id = (?)", current_user.profile_id ).first["email"] }).deliver
      authorize @organization
      redirect_to @organization , notice: "Correo enviado"
    end
    if current_user.investor?
      UserMailer.contact_org_email({ "email" => params["email"], "name" => params["name"],"projects" => params["projects"],"causes" => params["causes"], "comments" => params["comments"], "collaborator_name" => Investor.where("id = (?)", current_user.profile_id ).first["name"], "collaborator_email" => Investor.where("id = (?)", current_user.profile_id ).first["email"] }).deliver
      authorize @organization
      redirect_to @organization , notice: "Correo enviado"
    end
  end

  def login ()
  end

  def edit
    authorize @organization
  end

  def update 
 
    authorize @organization
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: I18n.t('organization.notices.updated') }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def download_csv_project
    respond_to do |format|
      @projects = Project.order(:name)
      format.csv
    end
  end

  def causes
    @organization = Organization.find(params[:organization_id])
    authorize @organization
  end
  
  private

  def organization_params
    params.require(:organization).permit(:name, :type_organization, :rfc, :foundation,
                                         :mision, :address, :colonia, :lat,:lng,:town,
                                         :zip, :telephone, :email, :site, :facebook,
                                         :twitter, :youtube, :instagram, :blog,:profile_url,
                                         :show_address, :show_town, :show_colonia,
                                         :rate_private, :rate_public, :rate_national, :rate_international, :rate_auto, :has_funding_national, :has_funding_international,
                                         :show_telephone, :show_zip, :show_email, :logo,:other_causes, causes_interest: [])
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
