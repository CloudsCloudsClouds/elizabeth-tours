class Avo::Dashboards::MainView < Avo::Dashboards::BaseDashboard
  self.id = "main_view"
  self.name = "Main view"
  # self.description = "Tiny dashboard description"
  # self.grid_cols = 3
  # self.visible = -> do
  #   true
  # end

  def cards
    # cards go here
    # card UsersCount
    card Avo::Cards::ExampleMetric
  end
end
