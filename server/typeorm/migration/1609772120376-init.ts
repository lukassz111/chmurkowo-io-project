import {MigrationInterface, QueryRunner} from "typeorm";

export class init1609772120376 implements MigrationInterface {
    name = 'init1609772120376'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query("CREATE TABLE `user` (`id` int NOT NULL AUTO_INCREMENT, `googleId` varchar(255) NOT NULL, `displayName` varchar(255) NOT NULL, `score` int NOT NULL, `premium` tinyint NOT NULL, `email` varchar(255) NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB");
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query("DROP TABLE `user`");
    }

}
