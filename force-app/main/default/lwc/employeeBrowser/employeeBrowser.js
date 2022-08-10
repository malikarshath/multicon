import { LightningElement,wire } from 'lwc';
import getEmployees from '@salesforce/apex/EmployeeBrowser.getEmployees';

export default class EmployeeBrowser extends LightningElement {
    employee = [];
    
    @wire(getEmployees,{ project: "", projectSkill:""}) employees;

}