import { LightningElement,api } from 'lwc';
import LOGO from '@salesforce/resourceUrl/hero_logo';

export default class HeroBanner extends LightningElement {
    @api title;
    @api logo=LOGO;

}