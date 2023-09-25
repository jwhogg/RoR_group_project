class SearchController < ApplicationController

	def show
		electives_all = Elective.all
		@search = params["search"]
		title = @search["Title"]
		features = ["Title","Description","Speciality","Location","Accommodation","WP_Support","Type"]
		conditions = {}
		if @search.present?
			features.each do |f|
				value = @search[f]
				unless value == "All" || value.blank?
					conditions[f] = value
				end
			end
			@electives = electives_all.where(conditions)
			respond_to do |format|
				format.js {render layout: false}
				format.html {render layout: false}
				format.any { head :not_acceptable }
			end
		end
	end

	def search
		@elective = Elective.new
	    electives = Elective.all
	    @locations = Array.new.push("All")
	    @specialities = Array.new.push("All")
	    @titles = Array.new.push("All")
	    @descriptions = Array.new.push("All")
	    @types = Array.new.push("All")
	    @wps = ["All", true, false]
	    @accommodaitons = ["All", true, false]

	    electives.each do |elective|
	      @locations.push(elective.Location)
	      @specialities.push(elective.Speciality)
	      @titles.push(elective.Title)
	      @descriptions.push(elective.Description)
	      @types.push(elective.Type)
	    end

	    @locations = @locations.uniq
	    @specialities = @specialities.uniq
	    @titles = @titles.uniq
	    @descriptions = @descriptions.uniq
	    @types = @types.uniq

	    @default = "All"
	end

end
