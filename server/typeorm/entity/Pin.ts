import {Column, Entity, ManyToOne, PrimaryGeneratedColumn} from "typeorm";
import { User } from "./User";

@Entity()
export class Pin {

    @PrimaryGeneratedColumn()
    id: number

    @Column()
    latitude: number

    @Column()
    longitude: number

    @Column()
    photo_filename: string

    @ManyToOne(() => User, user => user.pins)
    user: User

    public setDefault(
        latitude: number,longitude: number,
        photo_filename: string,user: User) {
            this.latitude = latitude
            this.longitude = longitude
            this.photo_filename = photo_filename
            this.user = user
    }
}
