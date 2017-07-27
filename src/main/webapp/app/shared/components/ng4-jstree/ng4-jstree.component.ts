import {AfterViewInit, Component, ElementRef, EventEmitter, Input, Output, ViewChild} from '@angular/core';

import * as jQuery from 'jquery';

@Component({
    selector: 'jhi-ng4-jstree',
    templateUrl: './ng4-jstree.component.html',
    styles: []
})
export class Ng4JstreeComponent implements AfterViewInit {

    @ViewChild('input') input: ElementRef;

    ngAfterViewInit() {
        jQuery(this.input.nativeElement).val('test');
    }

}
