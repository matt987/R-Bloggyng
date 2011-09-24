#!/usr/bin/ruby
#       Copyright 2011 Carlos Emanuel Mathiasen <matt987@mathiasen.com>
#                                Leandro Ariel Rodriguez <learod17@gmail.com>
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.

#requerimos la librería gtk
#depende de ruby-gnome2 - ruby-gnome-dev


require 'gtk2'


class Principal < Gtk::Window
   #constructor de la clase
   def initialize(usuario="")
        super
        Gtk.init
        #atributos de clase
        @usuario      = Usuario.find(usuario)
        @vbox          = Gtk::VBox.new(true,1)
        @table          = Gtk::Table.new(10,1,true)
        @combo       = Gtk::ComboBox.new #crea un combobox vacío
        @timeline     = Gtk::TextView.new
        @timeline_vbox = Gtk::VBox.new(true,1)
        @timeline_viewport = Gtk::Viewport.new(nil,nil)
        @rpost          = Gtk::TextView.new
        @buffer        = @rpost.buffer
        @scroll          = Gtk::ScrolledWindow.new
        @hbox          = Gtk::HBox.new(false, 5)
        @guardar     =  Gtk::Button.new(Gtk::Stock::APPLY)
        @cantidad = Gtk::Label.new("140")
        @buscar_alias     = Gtk::Entry.new
        @seguir = Gtk::Button.new('Seguir')
        set_windows
        #login.destroy
    end
   #setea los valores de la ventana
   def set_windows
        set_title  "R-Bloggyn::#{@usuario.alias}" #nombre de la ventana
        set_default_size 640, 480 #tamaño de la ventana
        set_skip_taskbar_hint true
        set_window_position Gtk::Window::POS_CENTER #posicion de la ventana
        self.set_attributes
        add @hbox
        show_all #muestra todo
   end
   def set_attributes
        self.in_vbox
        self.in_hbox
        self.in_scroll
        self.in_table
        self.text_view
        self.seniales
        #self.timeline_vbox
   end

   def text_view
     @rpost.set_wrap_mode(Gtk::TextTag::WRAP_WORD)
     @rpost.set_accepts_tab(false)
     #@timeline.set_wrap_mode(Gtk::TextTag::WRAP_WORD)
     #@timeline.editable=(false)
   end
   #carga la caja vertical con los atributos de clase
   def in_vbox
        @vbox.pack_start(@cantidad,     false,false,0)
        @vbox.pack_start(@guardar,       false, false, 0)
        @vbox.pack_start(@buscar_alias,       false, false, 0)
        @vbox.pack_start(@seguir,       false, false, 0)
   end
   #carga el scroll
   def in_scroll
        @scroll.border_width = 5
#         @scroll.add(@timeline_viewport)
        @scroll.add_with_viewport(@timeline_vbox)
        @scroll.set_policy(Gtk::POLICY_NEVER, Gtk::POLICY_ALWAYS)
   end

   def timeline_vbox()
      @usuario.siguiendo_posts.each do |post|
          label = Gtk::Label.new(post.text)
          label.set_wrap(Gtk::TextTag::WRAP_WORD)
          label2 = Gtk::Label.new(post.created_at.localtime.strftime('%d-%m-%Y - %H:%M'))
          frame = Gtk::Frame.new(post.usuario.alias)
          fixed = Gtk::Fixed.new
          fixed.put(label, 0, 2)
          fixed.put(label2, 270, 60)
          frame.add(fixed)
          @timeline_vbox.add(frame)
      end
      show_all
   end

   def in_hbox
        @hbox.pack_start(@table, true,  true, 0)
        @hbox.pack_start(@vbox,         false, true, 0)
   end
   def in_table
        options = Gtk::EXPAND|Gtk::FILL
        @table.attach(@rpost,  0,  1,  0,  2, options, options, 0,    0)
        @table.attach(@scroll,  0,  1,  2,  10, options, options, 0,    0)
   end
#    def set_buffer
#         @buffer.create_tag("bold",          {"weight"        => Pango::WEIGHT_BOLD})
#         @buffer.create_tag("italic",        {"style"         => Pango::STYLE_ITALIC})
#         @buffer.create_tag("strikethrough", {"strikethrough" => true})
#         @buffer.create_tag("underline",     {"underline"     => Pango::UNDERLINE_SINGLE})
#    end
   #agrega valores al atributo @combo
#    def combo_box
#      contenido = Array.new
#      #contenido[0] = self.text_scale("Cuarto de tamaño",      0.25)
#      contenido[0] = self.text_scale("Doble Extra Pequeño", Pango::SCALE_XX_SMALL)
#      contenido[1] = self.text_scale("Extra Pequeño",            Pango::SCALE_X_SMALL)
#      contenido[2] = self.text_scale("Pequeño",                      Pango::SCALE_SMALL)
#      contenido[3] = self.text_scale("Medio",                          Pango::SCALE_MEDIUM)
#      contenido[4] = self.text_scale("Grande",                        Pango::SCALE_LARGE)
#      contenido[5] = self.text_scale("Extra Grande",              Pango::SCALE_X_LARGE)
#      contenido[6] = self.text_scale("Doble Extra Grande",   Pango::SCALE_XX_LARGE)
#      contenido.each do |e|
#        @combo.append_text(e[:str])
#        @buffer.create_tag(e[:str], { "scale" => e[:scale] } )
#      end
#    end
    def seniales
        @buffer.signal_connect("mark-deleted") do|buffer,iter,text,length|
           @cantidad.set_text((140 - buffer.char_count  ).to_s)
            if buffer.char_count >= 140
              @guardar.set_sensitive(false)
            else
              @guardar.set_sensitive(true)
              @guardar
            end
     end

        signal_connect("destroy"){ Gtk.main_quit }#cuando se le da click al boton cerrar se cierra el programa
        @guardar.signal_connect("clicked")  do
          unless @rpost.buffer.char_count == 0 || @rpost.buffer.char_count >= 141
              @usuario.crear_post(@rpost.buffer.text)
              @timeline_vbox = Gtk::VBox.new(true,1)
              self.timeline_vbox()
              puts @rpost.buffer.text
              @rpost.buffer.text = ""
          else
            self.mensaje_dialogo "Ingrese texto" if @rpost.buffer.char_count == 0
            self.mensaje_dialogo "Cantidad de caracteres excedidos" if @rpost.buffer.char_count >= 139
          end
        end

        @seguir.signal_connect("clicked") do
            usuario = Usuario.find(:alias => @buscar_alias.text)
            unless usuario.blank?
              @usuario.aniadir_siguiendo(usuario)
              self.mensaje_dialogo('Ahora sigues a #{usuario.alias}')
            else
              self.mensaje_dialogo('Alias no encontrado, están correctos los datos?')
            end
          end
    end

    #crea un diálogo about.
    def about_dialogo
        about = Gtk::AboutDialog.new
        about.set_program_name "Prueba GTK JOINEA 2011"
        about.set_version "0.1"
        about.set_copyright "(cc) Carlos Mathiasen"
        about.set_comments "Una simple muestra de lo que se puede hacer con gtk y ruby"

        about.run
        about.destroy
    end

    #muestra un diálog según el valor pasado
    def mensaje_dialogo(string)
      md = Gtk::MessageDialog.new(self,
                                  Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::INFO,
                                  Gtk::MessageDialog::BUTTONS_CLOSE, string)
      md.run
      md.destroy
    end

end


# Gtk.init
# Principal.new
# Gtk.main