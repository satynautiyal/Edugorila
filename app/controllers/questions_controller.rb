class QuestionsController < ApplicationController
  before_action :set_question, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: %i{upload_question}
  # GET /questions or /questions.json
  def index
    redirect_to select_quiz_type_path(id: params[:id])
  end

  def select_quiz_type
    render layout: 'dashboaard'
  end

  def quiz_questions
    # abort('here')
    if params[:id].present?
      @questions = Question.where(subject_id: params[:id])
    else
      @questions = Question.all
    end
    unless session['previous_page'].nil?
      redirect_to session['previous_page']
      session['previous_page']=nil
    else
      @duration=@questions.first.subject.duration
      render layout: 'dashboaard'
    end
  end
  # GET /questions/1 or /questions/1.json
  def show
  end

  def test_result
    @questions=Question.where(subject_id: params[:subject_id])
    @score=0
    @result=Array.new   
    @questions.each_with_index  do |question,index|            
    
        if  question.correct_answer == params["submitted-answer#{question.id}"]
            @result << ["Q#{index+1}","Correct"]
            @score = @score+1
        else
            @result<<["Q#{index+1}","Incorrect","Correct answer was #{question.correct_answer}"]
        end
    end
    if admin_signed_in?
      Result.create(marks: @score, admin_id: current_admin.id,subject_id: params[:subject_id])
    end
    session['previous_page']="#{root_path}"
    render layout: 'dashboaard'
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions or /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to question_url(@question), notice: "Question was successfully created." }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_question
    file = params[:upload_file].tempfile
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
        all_question[index]['quiz_id']=params[:quiz_id]
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
    redirect_to questions_path(quiz_id: 1), notice: "Questions Created Successfully"
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to question_url(@question), notice: "Question was successfully updated." }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url, notice: "Question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:question, :options, :correct_answer, :quiz_id)
    end
end
