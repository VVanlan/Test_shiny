library(shiny)

ui <- fluidPage(
  selectInput(
    "n_breaks",
    label = "Number of bins in histogram (approximate):",
    choices = c(10, 20, 35, 50),
    selected = 20
  ),

  checkboxInput(
    "individual_obs",
    label = strong("Show individual observations"),
    value = FALSE
  ),

  checkboxInput(
    "density",
    label = strong("Show density estimate"),
    value = FALSE
  ),

  plotOutput("main_plot", height = "300px"),

  # Display this only if the density is shown
  conditionalPanel(condition = "input.density == true",
                   sliderInput(
                     "bw_adjust",
                     label = "Bandwidth adjustment:",
                     min = 0.2, max = 2, value = 1, step = 0.2)
  )
)

server <- function(input, output) {

  output$main_plot <- renderPlot({
    hist(
      bb$eruptions,
      probability = TRUE,
      breaks = as.numeric(input$n_breaks),
      xlab = "Duration (minutes)",
      main = "Geyser eruption duration"
    )

    if (input$individual_obs) {
      rug(bb$eruptions)
    }

    if (input$density) {
      dens <- density(bb$eruptions, adjust = input$bw_adjust)
      lines(dens, col = "blue")
    }
  })
}


shinyApp(ui, server)
