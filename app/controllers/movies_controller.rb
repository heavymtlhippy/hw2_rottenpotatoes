class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.all_ratings


    if params[:ratings].nil?
      @movies = Movie.find(:all)
      @selected_boxes = @all_ratings
    else
      @selected_boxes = params[:ratings].keys
      @movies = Movie.find(:all, :conditions => {
                             :rating => params[:ratings].keys})
      end




    if params[:sort].nil?
      @movies

    elsif params[:sort].to_s == "title" or params[:sort].to_s  == "release_date"
       @sorted_by = params[:sort]
      logger.info "params :sort value is: " + params[:sort] + " ASC"
      if( params[:sort] == 'title')
        @movies = @movies.sort_by{|movie| movie.title}
        elsif (params[:sort] == 'release_date')
        @movies = @movies.sort_by{|movie| movie.release_date}
        end

      logger.fatal "No movies!" unless @movies.count >= 1
    else
      logger.warn "Cannot Sort by: " + params[:sort]
      @movies = Movie.all
     end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
