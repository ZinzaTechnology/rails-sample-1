class CandidatesController < ApplicationController
  before_action :find_candidate, only: %i(show edit update)

  def index
    @search = Candidate.ransack(params[:q])
    @candidates = @search.result.id_desc.includes(:candidate_emails, :candidate_phones)
                         .page(params[:page]).per(Settings.number_per_page.candidates)
  end

  def new
    @candidate = Candidate.new
    build_association
  end

  def show
    authorize! :show, @candidate
  end

  def create
    @candidate = Candidate.new(candidate_params)
    if @candidate.save
      flash[:success] = t('.success')
      redirect_to candidate_path(@candidate)
    else
      build_association
      flash.now[:danger] = t('.failed')
      render :new
    end
  end

  def edit
    skill_collection
  end

  def update
    if @candidate.update(candidate_params)
      flash[:success] = t('.success')
      redirect_to candidate_path(@candidate)
    else
      skill_collection
      flash.now[:danger] = t('.failed')
      render :edit
    end
  end

  private

  def candidate_params
    standardize_candidate_params
    params.require(:candidate).permit(:name, :birth_y, :birth_m, :birth_d, :location, :note, :allow_coincide,
      candidate_emails_attributes: [:id, :email, :_destroy])
  end

  def standardize_candidate_params
    return unless personal_skills = params.dig(:candidate, :personal_skills)
    params[:candidate][:personal_skill_ids] = personal_skills.reject(&:blank?).map do |personal_skill|
      PersonalSkill.find_or_create_by(name: personal_skill).id
    end
  end

  def skill_collection
    @personal_skills = PersonalSkill.all.pluck(:name)
  end

  def find_candidate
    @candidate = Candidate.find(params[:id])
  end

  def attachment file_path
    File.open(Rails.root.join('public', 'uploads', 'tmp', file_path))
  end

  def build_association
    @candidate.candidate_emails.build
    skill_collection
  end
end
