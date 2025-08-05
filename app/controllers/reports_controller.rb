class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[ edit update destroy ]

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    @comment = Comment.new
  end

  def new
    @report = Report.new
  end

  def edit
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      redirect_to report_url(@report), notice: "Report was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      redirect_to report_url(@report), notice: "Report was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_url, notice: "Report was successfully destroyed."
  end

  private
    def set_report
      @report = Report.find(params[:id])
    end

    def authorize_user!
      redirect_to root_url, status: :see_other unless @report.user == current_user
    end

    def report_params
      params.require(:report).permit(:title, :content)
    end
end
