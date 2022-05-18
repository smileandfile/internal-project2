class Dashboard::FileDownloadController < Dashboard::DashboardController
  def index
    @file_downloads = FileDownload.all.order(created_at: :desc)
  end
end
