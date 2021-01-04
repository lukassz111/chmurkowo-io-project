import {Entity, PrimaryGeneratedColumn, Column, PrimaryColumn} from "typeorm";

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
}
