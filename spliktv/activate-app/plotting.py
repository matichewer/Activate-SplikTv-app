# GRAFICO PARA EL LOG DE SPLIKTV

# importo pandas para leer el log, y bokeh para crear el grafico
import pandas
from bokeh.plotting import figure, save
from bokeh.io import output_file, show
from bokeh.io import curdoc
from bokeh.models import DatetimeTickFormatter
from bokeh.models import WheelZoomTool
from bokeh.models import Range1d
from bokeh.models import HoverTool, ColumnDataSource

# seteo el nombre de las columnas
nombre_de_columnas = ["Fecha","Hora","Estado","Descripcion"]

# leo el log parseando fecha y hora
df = pandas.read_csv("/spliktv/logs/spliktv.log",
                     names = nombre_de_columnas,
                     parse_dates = ["Fecha","Hora"]
)

# filtro solamente las activaciones exitosas, el resto lo descarto
df = df.query('Descripcion == "activado"')

# seteo los ejes X,Y
x = df["Fecha"]
y = df["Hora"]

# creo el grafico
fig = figure(
        sizing_mode="stretch_both", # para que sea responsivo
        tools="pan,wheel_zoom,save,reset" # elijo los botones del costado a mostrar
    )
# seteo que por defecto este activado wheelzoom (hacer zoom con la ruedita del mouse)
fig.toolbar.active_scroll = fig.select_one(WheelZoomTool)

# formateo eje X
fig.xaxis.formatter=DatetimeTickFormatter(
        hours=["%d %B %Y"],
        days=["%d %B %Y"],
        months=["%d %B %Y"],
        years=["%d %B %Y"],
)

# inclino label de eje X
fig.xaxis.major_label_orientation = 3.14/4

# formateo eje Y
fig.yaxis.formatter=DatetimeTickFormatter(
        minutes=["%H:%M:%S"],
        hours=["%H:%M:%S"],
)

# personalizo cantidad de labels en cada eje
fig.xaxis[0].ticker.desired_num_ticks = 15
fig.yaxis[0].ticker.desired_num_ticks = 15

# seteo tema
temas = ['caliber','dark_minimal', 'light_minimal']
curdoc().theme = temas[1]


####### inicio seteo del popup para cada circulito ######
df["Fecha_string"]=df["Fecha"].dt.strftime("%Y-%m-%d")
df["Hora_string"]=df["Hora"].dt.strftime("%H:%M:%S")

cds = ColumnDataSource(data=dict(
    Fecha=df["Fecha"],
    Hora=df["Hora"],
    Fecha_string=df["Fecha_string"],
    Hora_string=df["Hora_string"]
))

hover = HoverTool(tooltips=[
    ("Fecha", "@Fecha_string"),
    ("Hora", "@Hora_string")
])

fig.add_tools(hover)
###### fin de seteo de popup ######


# creo los puntos
fig.circle(x='Fecha', y='Hora',
           source=cds,
           size=7
)

# exporto el html
output_file("/spliktv/website/index.html")

# guardo el grafico
save(fig)
