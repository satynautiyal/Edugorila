class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[ show edit update destroy ]
  # GET /subjects or /subjects.json
  def index
    @subjects = Subject.all
    render layout: 'admin'

  end

  # GET /subjects/1 or /subjects/1.json
  def show
  end

  # GET /subjects/new
  def new

    @subject = Subject.new
    render layout: 'admin'

  end

  # GET /subjects/1/edit
  def edit
    render layout: 'admin'

  end

  # POST /subjects or /subjects.json
  def create
    @subject = Subject.new(subject_params)
    respond_to do |format|
      if @subject.save
        upload_question(params,@subject.id)
        format.html { redirect_to root_path, notice: "Subject was successfully created." }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1 or /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        upload_question(params,@subject.id)
        format.html { redirect_to root_path, notice: "Subject was successfully updated." }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1 or /subjects/1.json
  def destroy
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to subjects_url, notice: "Subject was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def subject_params
      params.require(:subject).permit(:name)
    end






    def upload_question(params,subject_id)
      file = params[:subject][:upload_file].tempfile
      all_question=[]
      option_value=[]
  
      answer_keys=["a"=>0,"b"=>1,"c"=>2,"d"=>3,"e"=>4,"f"=>5]
      index=-1
      option_no=1
      data=File.foreach(file).map { |line|
        if line.include? "QUES"
          option_no=1
          option_value=[]
          index=index+1
          all_question[index]={}
          all_question[index]['subject_id']=subject_id
        line= line.split('.')
          all_question[index]['question']=line[1].gsub(/\s+/, ' ')
        else
          if line.include? "("
            if line.include? "उत्तर"
              key=line.gsub(/\s+/, ' ').gsub('(','').gsub(')','').split('-').last.strip
              all_question[index]["correct_answer"]= option_value[answer_keys[0]["#{key}"]]
              option_no= option_no+1
            else
              option_value << line.gsub(/\s+/, ' ').split(')').last.strip
              all_question[index]["options"]=option_value
              option_no= option_no+1
            end
          end
        end  
      }  
  
      questions=Question.import all_question
      # redirect_to , notice: "Questions Created Successfully"
    end


end
