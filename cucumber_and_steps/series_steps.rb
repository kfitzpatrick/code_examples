# encoding: utf-8

Then /^I should( not)? see the series "([^\"]*)"$/ do |no, name|
  if no
    response.should_not have_tag("table#data_table tbody th", name)
  else
    webrat.simulate do
      response.should have_tag("table#data_table tbody th", :text => name, :count => 1)
    end
    
    webrat.automate do
      response.should have_selector("table#data_table tbody th:contains('#{name}')")
    end
  end
end

Given /^the report "([^\"]*)" has a series called "([^\"]*)"$/ do |report_name, series_name|
  report = Report.find_by_name!(report_name)
  report.series.make(:name => series_name)
end
