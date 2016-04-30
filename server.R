# server.R
library(dplyr)
library(stats)
library(reshape)
library(ggplot2)
library(ggthemes)
library(grid)

load("data/LC.RData")
source("helpers.R")

shinyServer(
  function(input, output, session) {
    my_data = reactive({
      filter(LC, 
             grade %in% input$grade,
             loanamnt >= input$loanamnt[1],
             loanamnt <= input$loanamnt[2],
             termmonths %in% input$termmonths,
             rate >= input$rate[1],
             rate <= input$rate[2],
             emp >= input$emp[1],
             emp <= input$emp[2],
             homeOwnership %in% input$homeOwnership,
             income >= input$income[1] * 1000,
             income <= input$income[2] * 1000,
             purpose %in% input$purpose,
             dti >= input$DTI[1],
             dti <= input$DTI[2],
             inqlast6mths >= input$inqlast6mths[1],
             inqlast6mths <= input$inqlast6mths[2],
             accounts >= input$accounts[1],
             accounts <= input$accounts[2],
             records >= input$records[1],
             records <= input$records[2],
             balance >= input$balance[1] * 1000,
             balance <= input$balance[2] * 1000,
             revol_util_new  >= input$revol_util_new [1],
             revol_util_new  <= input$revol_util_new [2])
    })
    
    save_data = reactive({
      list(to_invest = input$to_invest,
           start_date = input$start_date,
           max_amount = input$max_amount,
           re_invest = input$re_invest,
           cash_rate = input$cash_rate,
           Amount = input$Amount,
           Rate = input$Rate,
           FICOrange = input$FICOrange,
           LCgrade = input$LCgrade,
           Term = input$Term,
           Purpose = input$Purpose,
           Inquieries = input$Inquieries,
           Income = input$Income,
           Emp = input$Emp,
           DTI = input$DTI,
           Home = input$Home,
           Delinq = input$Delinq,
           Records = input$Records,
           Credit_History = input$Credit_History,
           Balance = input$Balance,
           Rev_util = input$Rev_util,
           Accounts = input$Accounts,
           Seed = input$Seed
      )
    })
    
    
    investment_result = reactive({
      input$Invest
      isolate(invest(my_data(),
                     input$to_invest,
                     input$start_date,
                     input$re_invest,
                     input$max_amount,
                     input$cash_rate,
                     input$Seed))
    })

    
    bub_plot_data = reactive({
      filter_plot_data(LC, input$sub_data)
    })
    
    
    observeEvent(input$Save, {
      tryCatch({
        saveData(save_data(), input$Name, outputDir)
        file_list2 = list.files(outputDir, full.names = F)
        updateSelectInput(session, "Select_load", choices = file_list2)
      })
    })
    
    
    loaded_data = reactive({
      input$Load
      isolate(loadData(input$Select_load))
    })
    
    
    
    observeEvent(input$Load, {
      tryCatch({

        updateSliderInput(session, "loanamnt", value = loaded_data()$loanamnt)
        updateSliderInput(session, "rate", value = loaded_data()$rate)
        updateCheckboxGroupInput(session, "grade", selected = loaded_data()$grade)
        updateCheckboxGroupInput(session, "termmonths", selected = loaded_data()$termmonths)
        updateCheckboxGroupInput(session, "purpose", selected = loaded_data()$purpose)
        updateSliderInput(session, "inqlast6mths", value = loaded_data()$inqlast6mths)
        updateSliderInput(session, "income", value = loaded_data()$income)
        updateSliderInput(session, "emp", value = loaded_data()$emp)
        updateSliderInput(session, "DTI", value = loaded_data()$DTI)
        updateCheckboxGroupInput(session, "homeownership", selected = loaded_data()$homeownership)
        updateSliderInput(session, "Delinq", value = loaded_data()$Delinq)
        updateSliderInput(session, "records", value = loaded_data()$records)
        updateSliderInput(session, "balance", value = loaded_data()$balance)
        updateSliderInput(session, "revol_util_new ", value = loaded_data()$revol_util_new)
        updateSliderInput(session, "accounts", value = loaded_data()$accounts)
      })
    })
    
 
    output$ratePrediction <- renderPrint({
      
        
        rate2 <- round(67.46 -  (-0.08754*input$DTI2) + 0.0965*input$Emp2 + (-0.1378*input$income2) + 0.0001375*input$loanamnt2, 2)
        
        if (rate2 < 5) rate2 <- 5 # miniumum rate is 5
        # --- build + display the output text ---------------------------------
        cat("\n==================================================\n\n\n")
        cat("              Interest Rate Prediction             \n\n\n")
        cat("\n==================================================\n")
        cat("Annual Income . . .        :",input$income2,",000  dollars \n")
        cat("Debt to Income Ratio . . . :",input$DTI2," \n")
        cat("Employment Length . . .    :",input$Emp2,"years \n")
        cat("Amount requested.          :",input$loanamnt2,"  dollars \n")
        cat("=====================================================\n\n\n\n\n\n")
        cat(">>>                Predicted interest:     ", rate2, "% \n\n\n\n")
      
    })
    

    
    
    ####################################
    observeEvent(input$Submit, {
      tryCatch({
        saveData(save_data(), input$Name_submit, outputDir)
        file_list2 = list.files(outputDir, full.names = F)
        updateSelectInput(session, "Select_load", choices = file_list2)
        
        x = investment_result()$summary
        tr = (tail(x$Principal, 1) + tail(x$Cash, 1) + tail(x$Reinvested, 1)) / input$to_invest
        submition_data = data_frame(
          Name = input$Name_submit,
          Full_Return = tr * 100,
          Annual_Return = (round(tr^(12/nrow(x)),3)-1)*100,
          Strategy = sprintf("%s_%s.RDS", input$Name_submit, as.integer(Sys.time()))
        )
        
        saveData(submition_data, input$Name_submit, submitDir)
        
      })
    })
    
    
    HOF = reactive({
      input$Submit
      submits_list = list.files(submitDir, full.names = TRUE)
      return(load_HOF(submits_list))
    })
    
    
    output$HOF = renderDataTable({
      HOF()
    })
    
    output$explore_plot = renderPlot({
      bub_plot(bub_plot_data(), input$Bub_category, input$Bub_x_axis, input$Bub_y_axis, input$Bub_size)
    })
    
    
    output$plot_amounts = renderPlot({
      plot_amounts(bub_plot_data(), input$Bub_category)
    })
    
    
    output$plot_number = renderPlot({
      plot_number(bub_plot_data(), input$Bub_category)
    })
    
    
    output$bub_data = renderDataTable(
      full_summup(bub_plot_data(), input$Bub_category)[,c(input$Bub_category, input$Bub_x_axis, input$Bub_y_axis, input$Bub_size)],
      options = list(searching = FALSE, paging = FALSE)
    )
    
    
    output$Remaining_Bub_Plot = renderText({ 
      paste0("Remaining Loans: ", prettyNum(nrow(bub_plot_data()), big.mark = ","), " for a total of: $", 
            prettyNum(sum(bub_plot_data()$loanamnt/1), big.mark = ","),".") 
    })
    
    
    output$Remaining = renderText({ 
      paste0("Remaining Loans: ", prettyNum(nrow(my_data()), big.mark = ","), " for a total of: $", 
            prettyNum(sum(my_data()$loanamnt/1), big.mark = ","),".") 
    })
    
    output$Investment_result = renderText({
      x = investment_result()$summary
      tr = tail(x$Principal, 1) + tail(x$Cash, 1) + tail(x$Reinvested, 1)
      paste0("You ended up with a final return of: $", prettyNum(round(tr,0), big.mark = ","),
             ". This corresponds to an annual return of: ", round((tr/input$to_invest)^(12/nrow(x))-1,3)*100, "%.")
    })
    
    
    output$plot1 = renderPlot({
      plot_portfolio(investment_result()$summary)
    })    
    
    
    output$Investment_summup = renderDataTable(
      if(input$Transpose) {
        transpose(investment_summup(investment_result()$portfolio))
      } else {
        investment_summup(investment_result()$portfolio)
      },
      options = list(searching = FALSE, paging = FALSE)
    )
    
    
    output$Portfolio = renderDataTable(
      investment_result()$portfolio_short,
      options = list(
        lengthMenu = list(c(20, 50, -1), c('20', '50', 'All')),
        pageLength = -1)
    )
    
    
  }
)