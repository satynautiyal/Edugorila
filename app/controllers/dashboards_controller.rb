class DashboardsController < ApplicationController
    def show

        # @dashboaard = Profile.new
        if current_admin.email == "admin@gmail.com"
            # render 
            @subjects = Subject.all

            render "subjects/index",layout: 'admin'

        else
        render layout: 'dashboaard'
        end
        
    end
  end