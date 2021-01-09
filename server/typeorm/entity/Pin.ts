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
}
