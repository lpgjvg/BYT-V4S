import { LightningElement, api } from 'lwc';
import chartjs from '@salesforce/resourceUrl/chartjs';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
export default class Gen_barchart extends LightningElement {
    @api chartConfig;
    myChart;
    
    
    isChartJsInitialized;
    renderedCallback() {
        if (this.isChartJsInitialized) {
            return;
        }
        // load chartjs from the static resource
        Promise.all([loadScript(this, chartjs)])
            .then(() => {
                this.isChartJsInitialized = true;
                const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                this.myChart = new window.Chart(ctx, JSON.parse(JSON.stringify(this.chartConfig)));
                
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading Chart',
                        message: error.message,
                        variant: 'error',
                    })
                );
            });
    }

  @api  UpdateChartData()
    {
        
        const ctx1 = this.template.querySelector('canvas.barChart').getContext('2d');
        if(this.myChart){
            this.myChart.destroy();
        }
        
        this.myChart = new window.Chart(ctx1, JSON.parse(JSON.stringify(this.chartConfig)));
        console.log('Chart Reload Attempted');
    }
}