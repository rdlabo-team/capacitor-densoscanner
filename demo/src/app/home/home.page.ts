import {Component, inject, OnDestroy, OnInit, signal} from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel } from '@ionic/angular/standalone';
import { DensoScanner } from '@rdlabo/capacitor-densoscanner';
import {
  DensoOnScannerStatusChangedEvent,
  DensoScannerEvent,
  DensoScannerPolarization,
  DensoScannerTriggerMode,
} from '../../../../src';
import { PluginListenerHandle } from '@capacitor/core';
import {ReaderService} from '../reader/reader.service';
import {ModalController} from '@ionic/angular/standalone';
import {ReaderPage} from '../reader/reader.page';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel],
})
export class HomePage implements OnInit, OnDestroy {
  listenerHandles: PluginListenerHandle[] = [];
  readonly isReady = signal<boolean>(false);
  readonly readerService = inject(ReaderService)
  readonly modalCtrl = inject(ModalController);
  constructor() {}

  async ngOnInit() {
    this.listenerHandles.push(
      await DensoScanner.addListener(DensoScannerEvent.OnScannerStatusChanged, (event) => {
        if (event.status === DensoOnScannerStatusChangedEvent.SCANNER_STATUS_CLAIMED) {
          this.isReady.set(true);
        } else {
          this.isReady.set(false);
        }
      }),
    );
    this.listenerHandles.push(
      await DensoScanner.addListener(DensoScannerEvent.ReadData, (event) => {
        this.readerService.codes.set([...new Set(event.codes.concat(this.readerService.codes()))]);
      }),
    );
  }

  ngOnDestroy() {
    this.listenerHandles.forEach((listenerHandle) => listenerHandle.remove());
  }

  attach() {
    DensoScanner.attach();
  }

  detach() {
    DensoScanner.detach();
  }

  async pullData() {
    const modal = await this.modalCtrl.create({
      component: ReaderPage,
    });
    await modal.present().then(() => DensoScanner.pullData());
    await modal.onWillDismiss();
    DensoScanner.close();
  }

  async openInventory() {
    const modal = await this.modalCtrl.create({
      component: ReaderPage,
    });
    await modal.present().then(() => DensoScanner.openInventory());
    await modal.onWillDismiss();
    DensoScanner.close();
  }

  async getSettings() {
    const settings = await DensoScanner.getSettings();
  }

  setSettings() {
    DensoScanner.setSettings({
      triggerMode: DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1,
      powerLevelRead: 30,
      session: 0,
      polarization: DensoScannerPolarization.POLARIZATION_BOTH,
    });
  }
}
