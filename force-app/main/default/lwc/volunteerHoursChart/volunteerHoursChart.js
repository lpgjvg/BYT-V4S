import { LightningElement, wire, api } from 'lwc';
import getHours from '@salesforce/apex/VolunteerController.getChartData';
import { refreshApex } from '@salesforce/apex';
 
export default class VolunteerHoursChart extends LightningElement {
    chartConfiguration;
    @api contactid;
    dataset_chart;
    error;
    data_set;
 
    @wire(getHours, {contactid: '$contactid'})
    getHours(result) {
        this.dataset_chart = result;
        if (result.error) {
            this.error = result.error;
            this.chartConfiguration = undefined;
            console.log('error => ', error);
        } else if (result.data) {
            this.data_set = result.data;
            let chartHoursData = [];
            let chartDateLabel = [];
            this.data_set.forEach(hrs => {
                chartHoursData.push(hrs.sumHours);
                chartDateLabel.push(hrs.strDateLabel);
            });
 
            this.chartConfiguration = {
                type: 'bar',
                data: {
                    datasets: [{
                            label: 'Volunteer Hours',
                            backgroundColor: this.cssvar('--chart-bg-color'),
                            data: chartHoursData,
                        }
                    ],
                    labels: chartDateLabel,
                },
                options: {responsive: true,
                    maintainAspectRatio: false},
            };
            console.log('data => ', this.chartConfiguration);
            this.error = undefined;
        }
    }

     cssvar(name) {
        return getComputedStyle(document.documentElement).getPropertyValue(name);
      }

      @api async handleChartRefreshFromParent(){
        console.log('Refresh from parent Attempted for charts');
        await refreshApex(this.dataset_chart);

        const chartBuilder = this.template.querySelector('c-chart-Builder'); 
        if (chartBuilder) {
            console.log('chartBuilder >> ' + chartBuilder);
            chartBuilder.UpdateChartData();
        }
    }
      
}