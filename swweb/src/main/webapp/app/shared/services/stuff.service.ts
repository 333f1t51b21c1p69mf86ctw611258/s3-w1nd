import { Injectable } from '@angular/core';

@Injectable()
export class StuffService {

    getCurrentDate() {
        const dateObj = new Date();
        const month = dateObj.getUTCMonth() + 1; // months from 1-12
        const day = dateObj.getUTCDate();
        const year = dateObj.getUTCFullYear();

        return {year, month, day};
    }
}
