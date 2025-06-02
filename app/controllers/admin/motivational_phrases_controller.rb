class Admin::MotivationalPhrasesController < ApplicationController
  before_action :require_admin
  before_action :set_motivational_phrase, only: [:edit, :update, :destroy] 

  def index
    @motivational_phrases = MotivationalPhrase.all.order(created_at: :desc)
  end

  def new
    @motivational_phrase = MotivationalPhrase.new
  end

  def create
    @motivational_phrase = MotivationalPhrase.new(motivational_phrase_params)
    if @motivational_phrase.save
      flash[:notice] = "Frase motivacional creada exitosamente."
      redirect_to admin_motivational_phrases_path
    else
      flash.now[:alert] = "Error al crear la frase."
      render :new, status: :unprocessable_entity
    end
  end # <--- ESTE ES EL 'end' QUE FALTABA PARA EL MÉTODO 'create'

  def edit
    # @motivational_phrase ya está disponible gracias a set_motivational_phrase
    # Esta acción renderizará app/views/admin/motivational_phrases/edit.html.erb
  end

  def update
    # @motivational_phrase es cargado por el before_action :set_motivational_phrase
    if @motivational_phrase.update(motivational_phrase_params)
      flash[:notice] = "Frase motivacional actualizada exitosamente."
      redirect_to admin_motivational_phrases_path # Redirige a la lista de frases
    else
      flash.now[:alert] = "Error al actualizar la frase."
      render :edit, status: :unprocessable_entity # Vuelve a mostrar el formulario de edición con errores
    end
  end

  def destroy
    # @motivational_phrase es cargado por el before_action :set_motivational_phrase
    if @motivational_phrase.destroy
      flash[:notice] = "Frase motivacional eliminada exitosamente."
    else
      # Esto podría ocurrir si hay callbacks que impiden la eliminación,
      # o problemas de base de datos, aunque es menos común para un destroy simple.
      flash[:alert] = "No se pudo eliminar la frase motivacional."
    end
    redirect_to admin_motivational_phrases_path # Redirige siempre a la lista de frases
  end

  private

  def set_motivational_phrase
    @motivational_phrase = MotivationalPhrase.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "La frase motivacional que buscas no fue encontrada."
    redirect_to admin_motivational_phrases_path
  end

  def motivational_phrase_params
    params.require(:motivational_phrase).permit(:content)
  end
end