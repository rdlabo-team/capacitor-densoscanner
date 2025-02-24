import {Injectable, signal} from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ReaderService {

  constructor() { }

  codes = signal<string[]>([]);
}
