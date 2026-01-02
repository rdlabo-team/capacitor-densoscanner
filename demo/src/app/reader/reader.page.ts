import { Component, inject, OnInit } from '@angular/core';

import { FormsModule } from '@angular/forms';
import {
  IonButton,
  IonButtons,
  IonContent,
  IonHeader,
  IonItem,
  IonLabel,
  IonList,
  IonTitle,
  IonToolbar,
} from '@ionic/angular/standalone';
import { ModalController } from '@ionic/angular/standalone';
import { ReaderService } from './reader.service';

@Component({
  selector: 'app-reader',
  templateUrl: './reader.page.html',
  styleUrls: ['./reader.page.scss'],
  standalone: true,
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar,
    FormsModule,
    IonButtons,
    IonButton,
    IonList,
    IonItem,
    IonLabel
],
})
export class ReaderPage implements OnInit {
  readonly modalCtrl = inject(ModalController);
  readonly readerService = inject(ReaderService);
  constructor() {}

  ngOnInit() {}
}
