import { LightningElement,api } from 'lwc';

export default class EmployeeTiles extends LightningElement {
    @api employeeList = [];
    selectedEmployeeId = '';
    handleEmployeeSelected(event){
        this.selectedEmployeeId=event.detail.employeeId;
    }
    @api setSelectedEmployee(employeeId) {
        this.selectedEmployeeId = employeeId;
	}
}