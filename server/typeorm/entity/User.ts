import {Entity, PrimaryGeneratedColumn, Column, PrimaryColumn, OneToMany} from "typeorm";
import { Util } from "../../Shared/Util";
import { Pin } from "./Pin";

@Entity()
export class User {

    @PrimaryGeneratedColumn()
    id: number

    @Column()
    googleId: string

    @Column()
    displayName: string

    @Column()
    score: number

    @Column()
    premium: boolean
    
    @Column()
    email: string

    @Column()
    photosLeft: number

    @Column()
    lastPhotoTimestamp: number

    @OneToMany(() => Pin, pin => pin.user)
    pins: Pin[]

    public setDefault(googleId: string, displayName: string, email: string) {
        this.googleId = googleId
        this.displayName = displayName
        this.email = email
        this.score = 0
        this.premium = false
        this.photosLeft = 10
        this.lastPhotoTimestamp = Util.getCurrentTimestamp() - (24*60*60)
    }
    public resetPhotosLeft() {
        this.photosLeft = 10
    }
}
