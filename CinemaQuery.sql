/*1. Выбрать все данные о залах.*/
SELECT *
FROM Hall

/*2. Выбрать название фильма, длительность, цену лицензии. Результат
отсортировать по названию фильма в лексикографическом порядке.*/

SELECT M.Name, M.Duration, M.Price
FROM Movie M
ORDER BY M.Name

/*3. Выбрать все данные о фильмах, для которых еще не выставлена
оценка.*/

SELECT M.*
FROM Movie M
WHERE NOT EXISTS(SELECT *
                 FROM Movie_Mark MM
                 WHERE MM.ID_Movie = M.ID_Movie)

/*4. Выбрать названия кинокомпаний, которые состоят с двух или трех
слов. Результат отсортировать по убыванию длины названия
телекомпании.*/

SELECT C.Name
FROM Company C
WHERE C.Name LIKE '% % %' OR C.Name LIKE '% %'
ORDER BY LEN(C.Name) DESC


/*5. Выбрать все данные о заказчиках – юридических лицах, в полном
наименовании которых есть символ “, или », или _, или –.*/

SELECT E.*
FROM Entity E
WHERE E.Name LIKE '“' OR E.Name LIKE '»' OR
      E.Name LIKE '|_' ESCAPE '|' OR E.Name LIKE '-'

/*6. Выбрать данные о заказах билетов за сегодняшний день*/

SELECT TIC.*
FROM Ticket TIC
WHERE CAST(TIC.Status_Time AS DATE) = GETDATE()
/*7. Выбрать названия и продолжительность для фильмов выпущенных с
2000 по 2010 годы.*/

SELECT M.Name, M.Duration
FROM Movie M
WHERE M.Release_Year BETWEEN 2000 AND 2010


/*8. Выбрать данные о фильмах с длительностью 30, 40, 50, 90 минут.
Результат отсортировать по длительности в порядке убывания и по
названию фильма в лексикографическом порядке.*/

SELECT M.*
FROM Movie M
WHERE M.Duration IN (30, 40, 50, 90)
ORDER BY M.Duration DESC, M.Name


/*9. Выбрать название фильма в первом столбце, а во втором столбце
вывести короткометражный фильм, если длительность фильма менее
52 минут, и полнометражный, если длительность фильма не менее 52
минут.*/

SELECT M.Name,
       CASE
         WHEN M.Duration < 52 THEN
           'Короткометражный фильм'
         ELSE
           'Полнометражный фильм'
       END
FROM Movie M

/*10.Выбрать название фильма, длительность, количество дней в прокате
название кинокомпании. */

SELECT M.Name, M.Duration, M.Rental_Days, C.Name
FROM Movie M JOIN
     Company_Movie CM ON
     M.ID_Movie = CM.ID_Movie JOIN
     Company C ON
     C.ID_Company = CM.ID_Company

/*11.Выбрать название фильма, длительность, название кинокомпании,
название страны, оценку, название рейтинговой системы, дату начала
сеанса, номер зала. Результат отсортировать по дате начала сеанса.*/

SELECT MOV.Name, MOV.Duration, COM.Name,
       MOV_MAR.Mark, REV.Name, SES.Start_Time,
       SES.ID_Hall
FROM Movie MOV JOIN
     Company_Movie COM_MOV ON
     MOV.ID_Movie = COM_MOV.ID_Movie LEFT JOIN
     Company COM ON
     COM.ID_Company = COM_MOV.ID_Company LEFT JOIN
     Country_Movie COU_MOV ON
     COU_MOV.ID_Movie = MOV.ID_Movie LEFT JOIN
     Country COU ON
     COU.ID_Country = COU_MOV.ID_Country LEFT JOIN
     Movie_Mark MOV_MAR ON
     MOV_MAR.ID_Movie = MOV.ID_Movie LEFT JOIN
     Reviewer REV ON
     REV.ID_Reviewer = MOV_MAR.ID_Reviewer LEFT JOIN
     Session SES ON
     SES.ID_Movie = MOV.ID_Movie
ORDER BY SES.Start_Time
     

/*12.Выбрать максимальную продолжительность фильма.*/

SELECT MAX(MOV.Duration)
FROM Movie MOV

/*13.Выбрать год выпуска самого старого фильма из имеющихся в БД.*/

SELECT MIN(MOV.Release_Year)
FROM Movie MOV

/*14.Выбрать для каждой страны, год и количество снятых в этом году
фильмов. Результат отсортировать по годам в порядке возрастания и по
количеству фильмов по убыванию.*/

SELECT COU.Name, MOV.Release_Year, COUNT(*)
FROM Country COU LEFT JOIN
     Country_Movie COU_MOV ON
     COU.ID_Country = COU_MOV.ID_Country LEFT JOIN
     Movie MOV ON
     MOV.ID_Movie = COU_MOV.ID_Movie
GROUP BY COU.ID_Country, COU.Name, MOV.Release_Year

/*15.Выбрать среднюю стоимость билетов, на конкретный сеанс (значение
подставьте сами)*/

SELECT AVG(TIC.Price)
FROM Session SES JOIN
     Ticket TIC ON
     SES.ID_Session = TIC.ID_Session
WHERE SES.ID_Session = 1

/*16.Выбрать для выкупленных билетов номер зала, ряд, номер места, время
начала сеанса, название фильма. В результат должны войти данные об
прошедших сеансах.*/

SELECT PL.ID_Hall, PL.Row, PL.Place_Number, SES.Start_Time, MOV.Name
FROM Ticket TIC JOIN
     Session SES ON
     SES.ID_Session = TIC.ID_Session JOIN
     Place PL ON
     PL.ID_Place = TIC.ID_Place JOIN
     Movie MOV ON
     MOV.ID_Movie = SES.ID_Movie JOIN
     Ticket_Status TIC_STAT ON
     TIC_STAT.Name = 'Куплен'

/*17.Выбрать для каждой кинокомпании количество выпущенных фильмов.
Результат отсортировать по количеству.*/

SELECT COUNT(DISTINCT COM_MOV.ID_Movie)
FROM Company COM LEFT JOIN
     Company_Movie COM_MOV ON
     COM.ID_Company = COM_MOV.ID_Company

/*18.Выбрать для каждого сеанса, который начинается сегодня, суммарное
количество мест.*/

SELECT COUNT(PL.ID_Place)
FROM Session SES LEFT JOIN
     Hall HAL ON
     HAL.ID_Hall = SES.ID_Hall LEFT JOIN
     Place PL ON
     PL.ID_Hall = HAL.ID_Hall
WHERE CAST(SES.Start_Time AS DATE) = GETDATE()

/*19.Выбрать название страны, название кинокомпании, количество
фильмов.*/

SELECT COU.Name, COM.Name, MOV.Name
FROM Country COU JOIN
     Company COM ON
     COM.ID_Country = COU.ID_Country JOIN
     Company_Movie COM_MOV ON
     COM_MOV.ID_Company = COM.ID_Company JOIN
     Movie MOV ON
     MOV.ID_Movie = COM_MOV.ID_Movie
     

/*20.Выбрать названия стран, в которых более 2 киностудии.*/

SELECT COU.Name
FROM Country COU JOIN
     Studio STUD ON
     STUD.ID_Country = COU.ID_Country
GROUP BY COU.ID_Country, COU.Name
HAVING COUNT(STUD.ID_Studio) > 2

/*21.Для каждой российской киностудии указать количество
короткометражных фильмов в одном столбце и количество
полнометражных фильмов - в другом.*/

SELECT STUD.ID_Studio, STUD.Name,
       COUNT(CASE
              WHEN MOV.Duration < 52 THEN
                1
             END),
       COUNT(CASE
              WHEN MOV.Duration > 52 THEN
                1
             END)
FROM Studio STUD LEFT JOIN
     Studio_Movie STUD_MOV ON
     STUD_MOV.ID_Studio = STUD.ID_Studio LEFT JOIN
     Movie MOV ON
     MOV.ID_Movie = STUD_MOV.ID_Movie JOIN
     Country COU ON
     COU.Name = 'Российская Федерация'

/*22.Вывести сумму выручки за прошлый месяц.*/

SELECT SUM(TIC.Price)
FROM Ticket TIC JOIN
     Ticket_Status TIC_STAT ON
     TIC_STAT.Name = 'Куплен'
WHERE DATEDIFF(MONTH, TIC.Status_Time, GETDATE()) = 1

/*23.!!!Выбрать количество сеансов зарубежных фильмов,
демонстрировавшихся только в одном зале.*/

SELECT COUNT(DISTINCT SES.ID_Session)
FROM Session SES JOIN
     Movie MOV ON
     SES.ID_Movie = MOV.ID_Movie LEFT JOIN
     Country_Movie COU_MOV ON
     COU_MOV.ID_Movie = MOV.ID_Movie JOIN
     Country COU ON
     COU.Name <> 'Российская Федерация'
WHERE NOT EXISTS(SELECT *
                 FROM Session SES1
                 WHERE SES.ID_Movie = SES1.ID_Movie AND
                       SES.ID_Hall <> SES1.ID_Hall)

--Предыдущий вариант
SELECT COUNT(DISTINCT SES.ID_Session)
FROM Session SES JOIN
     Movie MOV ON
     SES.ID_Movie = MOV.ID_Movie LEFT JOIN
     Country_Movie COU_MOV ON
     COU_MOV.ID_Movie = MOV.ID_Movie JOIN
     Country COU ON
     COU.Name <> 'Российская Федерация'
WHERE 1 = (SELECT COUNT(DISTINCT SES1.ID_Hall)
           FROM Session SES1 JOIN
                Hall HAL ON
                HAL.ID_Hall = SES1.ID_Hall
           WHERE SES1.ID_Movie = MOV.ID_Movie)

/*24.Выбрать номера залов, в которых демонстрировалось более 5
различных фильмов за один день, в прошлом месяце.*/

SELECT SES.ID_Hall
FROM Session SES
WHERE DATEDIFF(MONTH, SES.Start_Time, GETDATE()) = 1
GROUP BY SES.ID_Hall, CAST(SES.Start_Time AS DATE) 
HAVING COUNT(*) > 5


/*25. Выбрать id ролика, который показывался перед тремя субботними
сеансами.*/

SELECT SES_ADV.ID_Advertisement
FROM Session SES JOIN
     Session_Advertisement SES_ADV ON
     SES.ID_Session = SES_ADV.ID_Session
WHERE DATEPART(WEEKDAY, SES.Start_Time) = 6
GROUP BY SES.ID_Session, SES_ADV.ID_Advertisement
HAVING COUNT(SES_ADV.ID_Session) = 3

/*26.Выбрать все страны и если в стране есть кинокомпания, то ее название.*/
SELECT COU.Name, COM.Name
FROM Country COU LEFT JOIN
     Company COM ON
     COM.ID_Country = COU.ID_Country

/*27.Выбрать для всех фильмов название, название кинокомпании,
количество сеансов. В результирующую таблицу должны войти и те
фильмы, которые еще не демонстрировались. Результат отсортировать
по количеству сеансов в убывающем порядке.*/

SELECT MOV.Name, COM.Name, COUNT(SES.ID_Session)
FROM Movie MOV JOIN
     Company_Movie COM_MOV ON
     COM_MOV.ID_Movie = MOV.ID_Movie JOIN
     Company COM ON
     COM.ID_Company = COM_MOV.ID_Company LEFT JOIN
     Session SES ON
     SES.ID_Movie = MOV.ID_Movie
GROUP BY MOV.Name, COM.Name
ORDER BY MOV.NAME

/*28.Выбрать все данные по роликам, которые еще не демонстрировались.*/

SELECT ADV.*
FROM Advertisement ADV
WHERE NOT EXISTS(SELECT *
                 FROM Session_Advertisement SES_ADV
                 WHERE SES_ADV.ID_Advertisement = ADV.ID_Advertisement)
/*29.Выбрать название фильма с минимальным количеством дней в прокате*/

SELECT MOV.Name
FROM Movie MOV
WHERE MOV.Rental_Days = (SELECT MIN(MOV1.Rental_Days)
                         FROM Movie MOV1)

/*30.Выбрать название фильма с наименьшей ценой лицензии из фильмов,
которые показывали более n раз.*/
WITH CTE AS (
SELECT MOV.Name, MOV.Price
FROM Movie MOV JOIN
     Session SES ON
     SES.ID_Movie = MOV.ID_Movie
GROUP BY SES.ID_Session, MOV.ID_Movie, MOV.Name, MOV.Price
HAVING COUNT(*) > 3)

SELECT CTE1.Name
FROM CTE CTE1
WHERE CTE1.Price = (SELECT MIN(CTE2.Price)
                    FROM CTE CTE2)
/*31.!!!!!!!!!!!!!!!!!Выбрать свободные места на конкретный сеанс.*/

SELECT PL.Row, PL.Place_Number
FROM Ticket TIC JOIN
     Ticket_Status TIC_ST ON
     TIC.ID_Ticket_Status = TIC_ST.ID_Ticket_Status JOIN
     Place PL ON
     PL.ID_Place = TIC.ID_Place
WHERE TIC.ID_Session = 4 AND
      TIC_ST.Name <> 'Куплен' AND TIC_ST.Name <> 'Забронирован'


/*32.Выбрать время самого раннего сеанса на завтра.*/

SELECT MIN(SES.Start_Time)
FROM Session SES
WHERE DATEDIFF(DAY, SES.Start_Time, GETDATE()) = -1

/*33.Выбрать названия месяцев прошлого года, которые принесли
максимальную выручку.*/

WITH CTE AS(
SELECT DATENAME(MONTH, SES.Start_Time) AS [Название месяца], SUM(TIC.Price) AS [Выручка]
FROM Session SES JOIN
     Ticket TIC ON
     TIC.ID_Session = SES.ID_Session JOIN
     Ticket_Status TIC_ST ON
     TIC_ST.Name = 'Куплен'
--WHERE YEAR(SES.Start_Time) = YEAR(GETDATE()) - 1
GROUP BY DATENAME(MONTH, SES.Start_Time)
)

SELECT CTE1.[Название месяца]
FROM CTE CTE1
WHERE CTE1.Выручка = (SELECT MAX(CTE2.Выручка)
                      FROM CTE CTE2)

/*34.!!!!!!!!!!!!!!!!!!Выбрать залы, в которых демонстрировались только российские фильмы.*/
WITH CTE AS (
SELECT HAL.ID_Hall, COU.Name
FROM Hall HAL JOIN
     Session SES ON
     SES.ID_Hall = HAL.ID_Hall JOIN
     Movie MOV ON
     MOV.ID_Movie = SES.ID_Movie JOIN
     Country_Movie COU_MOV ON
     COU_MOV.ID_Movie = MOV.ID_Movie JOIN
     Country COU ON
     COU.ID_Country = COU_MOV.ID_Country
)
SELECT CTE1.ID_Hall
FROM CTE CTE1
WHERE CTE1.Name = 'Российская федерация' AND 
      NOT EXISTS(SELECT *
                 FROM CTE CTE2
                 WHERE CTE1.ID_Hall = CTE2.ID_Hall AND
                       CTE1.Name <> CTE2.Name)



/*35.!!!!!!!!!!!!!Выбрать залы, в которых сеансы начинаются в одно и то же время.*/

SELECT DISTINCT SES1.ID_Hall, SES2.ID_Hall
FROM Session SES1 JOIN
     Session SES2 ON
     SES1.ID_Hall <> SES2.ID_Hall
WHERE SES1.Start_Time = SES2.Start_Time

/*36.Выбрать id ролика, который показывался перед каждым сеансом в
течение последнего месяца.*/

SELECT SES_ADV.ID_Advertisement
FROM Session_Advertisement SES_ADV JOIN
     Session SES ON
     SES.ID_Session = SES_ADV.ID_Session AND DATEDIFF(MONTH, SES.Start_Time, GETDATE()) = 0
GROUP BY SES_ADV.ID_Advertisement, SES_ADV.ID_Session
HAVING COUNT(DISTINCT SES.ID_Session) = (SELECT COUNT(*)
                                         FROM Session SES1
                                         WHERE DATEDIFF(MONTH, SES1.Start_Time, GETDATE()) = 0)

/*37.Вывести слова “Есть фильмы с одинаковым названием” если есть
фильмы с совпадающим названием и вывести “Фильмы с
совпадающими названиями отсутствуют”, если таких фильмов нет.*/

SELECT CASE
       WHEN EXISTS(SELECT *
                   FROM Movie MOV1 JOIN
                        Movie MOV2 ON
                        MOV1.ID_Movie <> MOV2.ID_Movie
                   WHERE MOV1.Name = MOV2.Name)
       THEN 'Есть фильмы с одинаковым названием'
       ELSE 'Фильмы с совпадающими названиями отсутствуют'
       END


/*38.Выбрать название фильма, который демонстрировался во всех залах.*/

SELECT MOV.Name
FROM Session SES JOIN
     Movie MOV ON
     SES.ID_Movie = MOV.ID_Movie
GROUP BY MOV.ID_Movie, MOV.Name
HAVING COUNT(DISTINCT SES.ID_Hall) = (SELECT COUNT(*)
                                      FROM Hall HAL)
/*39. !!!Для каждого зала выбрать период времени между сеансами (когда в
нем нет сеанса) на сегодняшний день.????????????????*/

SELECT SES.ID_Hall,
       DATEADD(MINUTE, MOV.Duration, SES.Start_Time),
       (SELECT MIN(SES1.Start_Time)
        FROM Session SES1
        WHERE DATEDIFF(MINUTE, SES1.Start_Time, DATEADD(MINUTE, MOV.Duration, SES.Start_Time)) < 0 AND
              DATEDIFF(DAY, SES1.Start_Time, GETDATE()) = 0 AND
              SES1.ID_Hall = SES.ID_Hall)
FROM Session SES JOIN
     Movie MOV ON
     MOV.ID_Movie = SES.ID_Movie
WHERE DATEDIFF(DAY, SES.Start_Time, GETDATE()) = 0 

/*40.!!!!!!!!!!!!Выбрать для каждого сеанса, который начинается сегодня, суммарное
количество мест, количество проданных мест и количество свободных
мест.*/

SELECT SES.ID_Session,
       COUNT(TIC.ID_Place),
       COUNT(CASE
             WHEN TIC_ST.Name = 'Куплен'
             THEN 1
             END),
       COUNT(CASE
             WHEN TIC_ST.Name <> 'Куплен' AND TIC_ST.Name <> 'Забронирован'
             THEN 1
             END)
FROM Session SES JOIN
     Ticket TIC ON
     TIC.ID_Session = SES.ID_Session JOIN
     Ticket_Status TIC_ST ON
     TIC_ST.ID_Ticket_Status = TIC.ID_Ticket_Status
--WHERE DATEDIFF(DAY, SES.Start_Time, GETDATE()) = 0 
GROUP BY SES.ID_Session

/*41.Выбрать кинокомпании, у которых более n фильмов, и которые не
имеют короткометражных фильмов.*/

SELECT COM.Name
FROM Movie MOV JOIN
     Company_Movie COM_MOV ON
     MOV.ID_Movie = COM_MOV.ID_Movie JOIN
     Company COM ON
     COM.ID_Company = COM_MOV.ID_Company
WHERE NOT EXISTS(SELECT *
                 FROM Movie MOV1 JOIN
                      Company_Movie COM_MOV1 ON
                      MOV1.ID_Movie = COM_MOV1.ID_Movie
                 WHERE MOV1.Duration < 52)
GROUP BY COM.ID_Company, COM.Name
HAVING COUNT(*) > 0

/*42.Выбрать компании, чьи фильмы демонстрируются 
только по субботам и воскресеньям.*/

SELECT COM1.Name
FROM Company COM1
WHERE NOT EXISTS(SELECT *
                 FROM Movie MOV JOIN
                      Session SES ON
                      MOV.ID_Movie = SES.ID_Movie JOIN
                      Company_Movie COM_MOV ON
                      COM_MOV.ID_Movie = MOV.ID_Movie
                 WHERE NOT DATEPART(WEEKDAY, SES.Start_Time) IN (6,7) AND
                       COM_MOV.ID_Company = COM1.ID_Company)

/*43.!!!!Выбрать фильмы с наивысшими оценками по всем рейтинговым
системам.*/

SELECT MOV.ID_Movie, MOV.Name
FROM Movie MOV JOIN
     Movie_Mark MOV_MARK_TEMP ON
     MOV_MARK_TEMP.ID_Movie = MOV.ID_Movie
WHERE NOT EXISTS(SELECT *
                 FROM Reviewer REV JOIN
                      Movie_Mark MOV_MARK ON
                      MOV_MARK.ID_Reviewer = REV.ID_Reviewer AND MOV_MARK.ID_Movie = MOV.ID_Movie
                 WHERE MOV_MARK.Mark < (SELECT MAX(MOV_MARK.Mark)
                                        FROM Movie_Mark MOV_MARK JOIN
                                             Reviewer REV ON
                                             REV.ID_Reviewer = MOV_MARK.ID_Reviewer))
--Предыдущий вариант
SELECT MOV.ID_Movie, MOV.Name
FROM Movie MOV JOIN
     Movie_Mark MOV_MARK1 ON
     MOV_MARK1.ID_Movie = MOV.ID_Movie
WHERE NOT EXISTS(SELECT *
                 FROM Movie_Mark MOV_MARK
                 WHERE MOV_MARK.ID_Movie = MOV.ID_Movie AND MOV_MARK.Mark < 10)
GROUP BY MOV.ID_Movie, MOV.Name
HAVING COUNT(MOV_MARK1.ID_Reviewer) = (SELECT COUNT(*)
                                       FROM Reviewer REV)

/*44.Выбрать фильмы, демонстрируемые сегодня без предварительного
показа рекламных роликов.*/

SELECT MOV.Name
FROM Movie MOV JOIN
     Session SES ON
     SES.ID_Movie = MOV.ID_Movie LEFT JOIN
     Session_Advertisement SES_ADV ON
     SES_ADV.ID_Session = SES.ID_Session
WHERE DATEDIFF(DAY, SES.Start_Time, GETDATE()) = 0
GROUP BY SES.ID_Session, MOV.ID_Movie, MOV.Name
HAVING COUNT(SES_ADV.ID_Session) = 0


/*45.Выбрать кинокомпании, которые имеют 2 фильма с наивысшими
оценками, так и 2 фильма с самими низкими оценками.????????????????*/

WITH CTE AS(
SELECT COM.ID_Company, MOV.ID_Movie, 
       CASE
       WHEN NOT EXISTS(SELECT *
                       FROM Reviewer REV JOIN
                            Movie_Mark MOV_MARK ON
                            MOV_MARK.ID_Reviewer = REV.ID_Reviewer AND MOV_MARK.ID_Movie = MOV.ID_Movie
                       WHERE MOV_MARK.Mark > (SELECT MIN(MOV_MARK.Mark)
                                              FROM Movie_Mark MOV_MARK JOIN
                                                   Reviewer REV ON
                                                   REV.ID_Reviewer = MOV_MARK.ID_Reviewer))
       THEN 'С самыми низкими'
       WHEN NOT EXISTS(SELECT *
                       FROM Reviewer REV JOIN
                            Movie_Mark MOV_MARK ON
                            MOV_MARK.ID_Reviewer = REV.ID_Reviewer AND MOV_MARK.ID_Movie = MOV.ID_Movie
                       WHERE MOV_MARK.Mark < (SELECT MAX(MOV_MARK.Mark)
                                              FROM Movie_Mark MOV_MARK JOIN
                                                   Reviewer REV ON
                                                   REV.ID_Reviewer = MOV_MARK.ID_Reviewer))
       THEN 'С самыми высокими'
       END RAITING
FROM Company COM JOIN
     Company_Movie COM_MOV ON
     COM_MOV.ID_Company = COM.ID_Company JOIN
     Movie MOV ON
     MOV.ID_Movie = COM_MOV.ID_Movie JOIN
     Movie_Mark MOV_MARK_TEMP ON
     MOV_MARK_TEMP.ID_Movie = MOV.ID_Movie
)

SELECT COM.Name
FROM Company COM JOIN
     CTE CTE1 ON
     CTE1.ID_Company = COM.ID_Company
GROUP BY CTE1.ID_Company, COM.Name
HAVING COUNT(CASE
             WHEN RAITING = 'С самыми высокими'
             THEN 1
             END) = 2 AND
       COUNT(CASE
             WHEN RAITING = 'С самыми низкими'
             THEN 1
             END) = 2

/*46.Выбрать компании, у которых фильмов с самыми низкими оценками
больше, чем с высокими.????????????????*/

WITH CTE AS(
SELECT COM.ID_Company, MOV.ID_Movie, 
       CASE
       WHEN NOT EXISTS(SELECT *
                       FROM Reviewer REV JOIN
                            Movie_Mark MOV_MARK ON
                            MOV_MARK.ID_Reviewer = REV.ID_Reviewer AND MOV_MARK.ID_Movie = MOV.ID_Movie
                       WHERE MOV_MARK.Mark > (SELECT MIN(MOV_MARK.Mark)
                                              FROM Movie_Mark MOV_MARK JOIN
                                                   Reviewer REV ON
                                                   REV.ID_Reviewer = MOV_MARK.ID_Reviewer))
       THEN 'С самыми низкими'
       WHEN NOT EXISTS(SELECT *
                       FROM Reviewer REV JOIN
                            Movie_Mark MOV_MARK ON
                            MOV_MARK.ID_Reviewer = REV.ID_Reviewer AND MOV_MARK.ID_Movie = MOV.ID_Movie
                       WHERE MOV_MARK.Mark < 5)
       THEN 'С высокими'
       END RAITING
FROM Company COM JOIN
     Company_Movie COM_MOV ON
     COM_MOV.ID_Company = COM.ID_Company JOIN
     Movie MOV ON
     MOV.ID_Movie = COM_MOV.ID_Movie JOIN
     Movie_Mark MOV_MARK_TEMP ON
     MOV_MARK_TEMP.ID_Movie = MOV.ID_Movie
)

SELECT COM.Name
FROM Company COM JOIN
     CTE CTE1 ON
     CTE1.ID_Company = COM.ID_Company
GROUP BY CTE1.ID_Company, COM.Name
HAVING COUNT(CASE
             WHEN RAITING = 'С самыми низкими'
             THEN 1
             END) >
       COUNT(CASE
             WHEN RAITING = 'С высокими'
             THEN 1
             END)

/*47.Выбрать ролик, который демонстрируется чаще других.*/

SELECT ADV.ID_Advertisement
FROM Session_Advertisement SES_ADV JOIN
     Advertisement ADV ON
     SES_ADV.ID_Advertisement = ADV.ID_Advertisement
GROUP BY ADV.ID_Advertisement
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                       FROM Session_Advertisement SES_ADV1 JOIN
                            Advertisement ADV1 ON
                            SES_ADV1.ID_Advertisement = ADV1.ID_Advertisement
                       WHERE ADV1.ID_Advertisement <> ADV.ID_Advertisement
                       GROUP BY ADV1.ID_Advertisement)
/*48.Выбрать id и название фильма, который демонстрировался во всех
зимних месяцах прошлого года по два раза.*/

WITH CTE AS(
SELECT SES.ID_Movie,
       COUNT(CASE
             WHEN MONTH(SES.Start_Time) = 1
             THEN 1
             END) AS JANUARY,
       COUNT(CASE
             WHEN MONTH(SES.Start_Time) = 2
             THEN 1
             END) AS FEBRARY,
       COUNT(CASE
             WHEN MONTH(SES.Start_Time) = 12
             THEN 1
             END) AS DECEMBER
FROM Session SES
WHERE DATEDIFF(YEAR, SES.Start_Time, GETDATE()) = 1
GROUP BY SES.ID_Movie
)
SELECT MOV.ID_Movie, MOV.Name
FROM CTE CTE1 JOIN
     Movie MOV ON
     MOV.ID_Movie = CTE1.ID_Movie
WHERE CTE1.DECEMBER = 2 AND CTE1.FEBRARY = 2 AND CTE1.JANUARY = 2

/*49.Выбрать дату, когда можно смотреть фильмы без перерыва, переходя
из зала в зал весь день, т.е. время конца одного фильма совпадает с
временем начала другого фильма*/

WITH CTE AS (
SELECT SES.ID_Session, SES.Start_Time, DATEADD(MINUTE, MOV.Duration, SES.Start_Time) AS END_TIME
FROM Session SES JOIN
     Movie MOV ON
     MOV.ID_Movie = SES.ID_Movie
WHERE DATEPART(HOUR, SES.Start_Time) = 0 AND 
      DATEPART(MINUTE, SES.Start_Time) = 0 AND
      DATEPART(SECOND, SES.Start_Time) = 0
UNION ALL
SELECT SES.ID_Session, SES.Start_Time, DATEADD(MINUTE, MOV.Duration, SES.Start_Time) AS END_TIME
FROM Session SES JOIN
     Movie MOV ON
     MOV.ID_Movie = SES.ID_Movie JOIN
     CTE CTE1 ON
     CTE1.END_TIME = SES.Start_Time
WHERE CAST(SES.Start_Time AS DATE) = CAST(CTE1.END_TIME AS DATE) AND
      CTE1.END_TIME = SES.Start_Time)

SELECT DISTINCT CAST(CTE1.Start_Time AS DATE)
FROM CTE CTE1
WHERE DATEDIFF(DAY, CTE1.Start_Time, CTE1.END_TIME) = 1 
