////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность 
//             электронного документооборота с контролирующими органами". 
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Проверка наличия подключения к интернету
// (см. http://technet.microsoft.com/en-us/library/cc766017(WS.10).aspx)
//
// Возвращаемое значение:
// 	Булево - признак наличия подключения к интернету.
//
Функция ЕстьПодключениеКИнтернету() Экспорт
	
	Соединение = Новый HTTPСоединение("www.msftncsi.com",,,,, 10);
	Запрос = Новый HTTPЗапрос("/ncsi.txt");
	Попытка
		Ответ = Соединение.Получить(Запрос);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Если Ответ.КодСостояния = 200
		И Ответ.ПолучитьТелоКакСтроку() = "Microsoft NCSI" Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

// Устанавливает соединение с сервером Интернета по протоколу http(s).
//
// Параметры:
//  URL                 - Строка - url сервера в формате [Протокол://]<Сервер>/.
//  ПараметрыСоединения - Структуруа - дополнительные параметры для "тонкой" настройки.
//    * Таймаут - Число - определяет время ожидания осуществляемого соединения и операций, в секундах.
//
Функция СоединениеССерверомИнтернета(URL, ПараметрыСоединения = Неопределено) Экспорт

	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	Схема = ?(ЗначениеЗаполнено(СтруктураURI.Схема), СтруктураURI.Схема, "http");
	Прокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси(Схема);
	
	Таймаут = 30;
	Если ТипЗнч(ПараметрыСоединения) = Тип("Структура") Тогда
		Если ПараметрыСоединения.Свойство("Таймаут") Тогда
			Таймаут = ПараметрыСоединения.Таймаут;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		Соединение = Новый HTTPСоединение(
			СтруктураURI.Хост,
			СтруктураURI.Порт,
			СтруктураURI.Логин,
			СтруктураURI.Пароль, 
			Прокси,
			Таймаут,
			?(НРег(Схема) = "http", Неопределено, ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение()));
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();	
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронный документооборот с контролирующими органами. Установление соединения с сервером интернета'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

// Возвращает записи присоединенных файлов объекта.
//
// Параметры:
//  Объект                       - Ссылка - ссылка на объект, который может содержать присоединенные файлы,
//                               - Массив - массив ссылок на объекты.
//  ИменаСправочников            - Строка - имена справочников присоединенных файлов через запятую, при пустом значении
//                                 используется имя справочника по умолчанию,
//                               - Неопределено - использовать имя справочника по умолчанию,
//                                 при равенстве Неопределено параметров ИменаСправочников, ИсходноеИмяФайла,
//                                 ПоляПрисоединенногоФайла и если в параметре Объект передан не массив, в параметре
//                                 ВключатьПомеченныеНаУдаление передана Истина, используется стандартная процедура,
//                                 возвращающая массив ссылок на присоединенные файлы из всех справочников присоединенных
//                                 файлов объекта.
//  ИсходноеИмяФайла             - Строка - исходное имя присоединенного файла, хранимое в ресурсе ИсходноеИмяФайла,
//                                 не ограничено 150 символами, как имя файла без расширения в стандартном реквизите Наименование,
//                                 при пустом значении возвращаются все файлы,
//                               - Неопределено - вернуть все файлы, см. также ИменаСправочников.
//  ПоляПрисоединенногоФайла     - Строка - возвращаемые поля справочника присоединенных файлов через запятую,
//                                 при непустом значении возвращается таблица значений, первая колонка содержит ссылку
//                                 на присоединенный файл, следующие колонки соответствуют перечисленным полям
//                                 справочника, при пустом значении возвращается массив ссылок на присоединенные файлы.
//                                 Неопределено - вернуть только ссылки на присоединенные файлы,
//                                 см. также ИменаСправочников.
//  ВключатьПомеченныеНаУдаление - Булево - при значении Истина возвращать также помеченные на удаление.
//
// Возвращаемое значение:
//  Массив                       - массив ссылок на присоединенные файлы, возвращается при пустом значении
//                                 ПоляПрисоединенногоФайла,
//  ТаблицаЗначений              - таблица со ссылками на присоединенные файлы в первой колонке, значениями
//                                 перечисленных в ПоляПрисоединенногоФайла полей справочника присоединенных файлов
//                                 в следующих колонках.
//
Функция ПрикрепленныеФайлыКОбъектуИзСправочника(
	Знач Объект,
	Знач ИменаСправочников = Неопределено,
	Знач ИсходноеИмяФайла = Неопределено,
	Знач ПоляПрисоединенногоФайла = Неопределено,
	Знач ВключатьПомеченныеНаУдаление = Ложь) Экспорт
	
	Если ТипЗнч(Объект) <> Тип("Массив") И ИменаСправочников = Неопределено И ИсходноеИмяФайла = Неопределено
		И ПоляПрисоединенногоФайла = Неопределено И ВключатьПомеченныеНаУдаление Тогда
		// чтение из всех справочников присоединенных файлов объекта
		МассивФайлов = Новый Массив;
		РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(Объект, МассивФайлов);
		Возврат МассивФайлов;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИменаСправочников) Тогда
		ТипВладельцаФайлов = ТипЗнч(Объект);
		Если ТипВладельцаФайлов = Тип("Массив") Тогда
			ТипВладельцаФайлов = ТипЗнч(Объект[0]);
		КонецЕсли;
		МетаданныеВладельца = Метаданные.НайтиПоТипу(ТипВладельцаФайлов);
		ИменаСправочников = МетаданныеВладельца.Имя + "ПрисоединенныеФайлы";
	КонецЕсли;
	
	МассивИменСправочников = СтрРазделить(ИменаСправочников, ",");
	
	Если ЗначениеЗаполнено(ПоляПрисоединенногоФайла) Тогда
		МассивПолей = СтрРазделить(ПоляПрисоединенногоФайла, ",");
		Для ИндексМассива = 0 По МассивПолей.Количество() - 1 Цикл
			ИмяПоля = СокрЛП(МассивПолей[ИндексМассива]);
			МассивПолей[ИндексМассива] = "ПрисоединенныеФайлы." + ИмяПоля + " КАК " + ИмяПоля;
		КонецЦикла;
		ПоляПрисоединенногоФайла = СтрСоединить(МассивПолей, ",
			|");
	КонецЕсли;
	
	ТекстЗапросов = "";
	Для каждого ЭлементМассива Из МассивИменСправочников Цикл
		ИмяСправочника = СокрЛП(ЭлементМассива);
		Если ЗначениеЗаполнено(ТекстЗапросов) Тогда
			ТекстЗапросов = ТекстЗапросов + "
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|";
		КонецЕсли;
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	ПрисоединенныеФайлы.Ссылка КАК Ссылка" + ?(ЗначениеЗаполнено(ПоляПрисоединенногоФайла), ",
			|	" + ПоляПрисоединенногоФайла, "") + "
			|ИЗ
			|	&ИмяСправочника КАК ПрисоединенныеФайлы
			|ГДЕ
			|	ПрисоединенныеФайлы.ВладелецФайла" + ?(ТипЗнч(Объект) = Тип("Массив"),
					" В (&ВладелецФайлов)", " = &ВладелецФайлов") + ?(ЗначениеЗаполнено(ИсходноеИмяФайла), "
			|	И ПрисоединенныеФайлы.ИсходноеИмяФайла = &ИсходноеИмяФайла", "") + ?(НЕ ВключатьПомеченныеНаУдаление, "
			|	И НЕ ПрисоединенныеФайлы.ПометкаУдаления", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяСправочника", "Справочник." + ИмяСправочника);
		ТекстЗапросов = ТекстЗапросов + ТекстЗапроса;
	КонецЦикла;
	
	Запрос = Новый Запрос(ТекстЗапросов);
	Запрос.УстановитьПараметр("ВладелецФайлов", Объект);
	Если ЗначениеЗаполнено(ИсходноеИмяФайла) Тогда
		Запрос.УстановитьПараметр("ИсходноеИмяФайла", ИсходноеИмяФайла);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоляПрисоединенногоФайла) Тогда
		Возврат Запрос.Выполнить().Выгрузить();
	Иначе
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
КонецФункции

// Возвращает массив с описаниями и данными файлов внутри архива zip.
//
// Параметры:
//  ИмяФайлаПотокИлиДвоичныеДанные - Строка, Поток, ДвоичныеДанные - zip-архив.
//  ВозвращатьМассивПриОшибке      - Булево - возвращать массив прочитанной информации о файлах, если формат
//                                   последнего файла некорректный и количество корректных файлов больше нуля.
//
// Возвращаемое значение:
//  Массив       - информация о файлах в архиве.
//    * ФорматНеПоддерживается   - Булево - формат файла некорректный, обработка на этом файле прекращается.
//    * Версия                   - Число.
//    * МетодСжатия              - Число - 0 - без сжатия, 8 - Deflate.
//    * Дата                     - Дата.
//    * КонтрольнаяСумма         - Число.
//    * ДлинаРаспакованныхДанных - Число.
//    * ИмяФайла                 - Строка.
//    * УпакованныеДанные        - БуферДвоичныхДанных.
//  Неопределено - формат последнего файла некорректный и значение параметра ВозвращатьМассивПриОшибке равно Ложь
//                 либо архив не содержит корректных файлов.
//
Функция МассивОписанийИДанныхZipФайла(ИмяФайлаПотокИлиДвоичныеДанные, ВозвращатьМассивПриОшибке = Ложь) Экспорт
	
	Результат = Новый Массив;
	
	ОбъектЧтениеДанных = Новый ЧтениеДанных(ИмяФайлаПотокИлиДвоичныеДанные);
	
	Пока Истина Цикл
		ИнформацияОФайле = Новый Структура;
		ИнформацияОФайле.Вставить("ФорматНеПоддерживается", 	Ложь);
		ИнформацияОФайле.Вставить("Версия", 					Неопределено);
		ИнформацияОФайле.Вставить("МетодСжатия", 				Неопределено);
		ИнформацияОФайле.Вставить("Дата", 						Неопределено);
		ИнформацияОФайле.Вставить("КонтрольнаяСумма", 			Неопределено);
		ИнформацияОФайле.Вставить("ДлинаРаспакованныхДанных", 	Неопределено);
		ИнформацияОФайле.Вставить("ИмяФайла", 					Неопределено);
		ИнформацияОФайле.Вставить("УпакованныеДанные", 			Неопределено);
		
		ЗаголовокZip1 = ОбъектЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(30);
		
		Если ЗаголовокZip1.Размер < 30
			ИЛИ ЗаголовокZip1[0] <> КодСимвола("P") ИЛИ ЗаголовокZip1[1] <> КодСимвола("K")
			ИЛИ ЗаголовокZip1[2] <> 3 ИЛИ ЗаголовокZip1[3] <> 4
			ИЛИ ПобитовоеИ(ЗаголовокZip1[6], 8) = 8 Тогда // неопределенная длина, не поддерживается
			
			Если ЗаголовокZip1.Размер = 0 ИЛИ ЗаголовокZip1.Размер >= 4
				И ЗаголовокZip1[0] = КодСимвола("P") И ЗаголовокZip1[1] = КодСимвола("K")
				И ЗаголовокZip1[2] = 1 ИЛИ ЗаголовокZip1[3] = 2 Тогда
				
				Прервать;
			КонецЕсли;
			
			ИнформацияОФайле.ФорматНеПоддерживается = Истина;
			Результат.Добавить(ИнформацияОФайле);
			Прервать;
		КонецЕсли;
		
		ИнформацияОФайле.Версия = ЗаголовокZip1[4];
		КодировкаИмениФайла = ?(ПобитовоеИ(ЗаголовокZip1[7], 8) = 8, "utf-8", "cp866");
		ИнформацияОФайле.МетодСжатия = ЗаголовокZip1.ПрочитатьЦелое16(8);
		
		ДатаЧислом = ЗаголовокZip1.ПрочитатьЦелое32(10);
		ДниМесяцыГоды = Цел(ДатаЧислом / 65536);
		ЧасыМинутыСекунды = ДатаЧислом % 65536;
		ДеньДаты = ДниМесяцыГоды % 32;
		МесяцДаты = Цел(ДниМесяцыГоды / 32) % 16;
		МесяцДаты = ?(МесяцДаты < 1, 1, ?(МесяцДаты > 12, 12, МесяцДаты));
		ГодДаты = Цел(ДниМесяцыГоды / 512) + 1980;
		ДатаКонцаМесяца = Дата(ГодДаты, МесяцДаты, 1);
		ДатаКонцаМесяца = КонецМесяца(ДатаКонцаМесяца);
		ДеньКонцаМесяца = День(ДатаКонцаМесяца);
		ДеньДаты = ?(ДеньДаты < 1, 1, ?(ДеньДаты > ДеньКонцаМесяца, ДеньКонцаМесяца, ДеньДаты));
		СекундаДаты = ЧасыМинутыСекунды % 32 * 2;
		СекундаДаты = ?(СекундаДаты > 59, 59, СекундаДаты);
		МинутаДаты = Цел(ЧасыМинутыСекунды / 32) % 64;
		МинутаДаты = ?(МинутаДаты > 59, 59, МинутаДаты);
		ЧасДаты = Цел(ЧасыМинутыСекунды / 2048);
		ЧасДаты = ?(ЧасДаты > 23, 23, ЧасДаты);
		ИнформацияОФайле.Дата = Дата(ГодДаты, МесяцДаты, ДеньДаты, ЧасДаты, МинутаДаты, СекундаДаты);
		
		ИнформацияОФайле.КонтрольнаяСумма = ЗаголовокZip1.ПрочитатьЦелое32(14);
		ДлинаУпакованныхДанных = ЗаголовокZip1.ПрочитатьЦелое32(18);
		ИнформацияОФайле.ДлинаРаспакованныхДанных = ЗаголовокZip1.ПрочитатьЦелое32(22);
		ДлинаИмениФайла = ЗаголовокZip1.ПрочитатьЦелое16(26);
		ДлинаДополнительногоПоля = ЗаголовокZip1.ПрочитатьЦелое16(28);
		
		ДлинаФайлаСДополнительнымиДанными = ДлинаИмениФайла + ДлинаДополнительногоПоля + ДлинаУпакованныхДанных;
		ФайлСДополнительнымиДанными = ОбъектЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(ДлинаФайлаСДополнительнымиДанными);
		
		Если ФайлСДополнительнымиДанными.Размер < ДлинаФайлаСДополнительнымиДанными Тогда
			ИнформацияОФайле.ФорматНеПоддерживается = Истина;
			Результат.Добавить(ИнформацияОФайле);
			Прервать;
		КонецЕсли;
		
		БуферИмениФайла = ?(ДлинаИмениФайла > 0, ФайлСДополнительнымиДанными.ПолучитьСрез(0, ДлинаИмениФайла),
			Новый БуферДвоичныхДанных(0));
		ПотокИмениФайла = Новый ПотокВПамяти(БуферИмениФайла);
		ДанныеИмениФайла = ПотокИмениФайла.ЗакрытьИПолучитьДвоичныеДанные();
		ИнформацияОФайле.ИмяФайла = ПолучитьСтрокуИзДвоичныхДанных(ДанныеИмениФайла, КодировкаИмениФайла);
		
		ИнформацияОФайле.УпакованныеДанные = ?(ДлинаУпакованныхДанных > 0, ФайлСДополнительнымиДанными.ПолучитьСрез(
			ДлинаИмениФайла + ДлинаДополнительногоПоля, ДлинаУпакованныхДанных), Новый БуферДвоичныхДанных(0));
		
		Результат.Добавить(ИнформацияОФайле);
	КонецЦикла;
	
	ОбъектЧтениеДанных.Закрыть();
	
	Если Результат.Количество() = 0
		ИЛИ Результат.Количество() = 1 И Результат[0].ФорматНеПоддерживается
		ИЛИ НЕ ВозвращатьМассивПриОшибке И Результат[Результат.Количество() - 1].ФорматНеПоддерживается Тогда
		
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// По описаниям и данным файлов записывает архив gzip (формат обычно используется для сжатия одного файла).
//
//  МассивОписанийИДанных - Массив - информация о файлах в архиве.
//    * МетодСжатия              - Число - 8 - Deflate.
//    * Дата                     - Дата.
//    * КонтрольнаяСумма         - Число.
//    * ДлинаРаспакованныхДанных - Число.
//    * ИмяФайла                 - Строка - может быть пустым.
//    * УпакованныеДанные        - БуферДвоичныхДанных.
//  ИмяФайлаИлиПоток      - Строка, Поток - файл для сохранения gzip-архива.
//
Процедура СформироватьGzip(МассивОписанийИДанных, ИмяФайлаИлиПоток) Экспорт
	
	ЗаписьДанныхGzip = Новый ЗаписьДанных(ИмяФайлаИлиПоток);
	ТекущийЧасовойПояс = ЧасовойПоясСеанса();
	
	Для каждого ОписаниеИДанные Из МассивОписанийИДанных Цикл
		ДлинаИмениФайла = 0;
		Если ЗначениеЗаполнено(ОписаниеИДанные.ИмяФайла) Тогда
			БуферИмениФайла = ПолучитьБуферДвоичныхДанныхИзСтроки(ОписаниеИДанные.ИмяФайла, "windows-1251");
			ДлинаИмениФайла = БуферИмениФайла.Размер + 1;
		КонецЕсли;
		
		БуферЗаголовка = Новый БуферДвоичныхДанных(10 + ДлинаИмениФайла);
		
		БуферЗаголовка[0] = 31; // ID1
		БуферЗаголовка[1] = 139; // ID2
		БуферЗаголовка[2] = ОписаниеИДанные.МетодСжатия;
		БуферЗаголовка[3] = ?(ЗначениеЗаполнено(ОписаниеИДанные.ИмяФайла), 8, 0); // флаги
		ДатаЧислом = УниверсальноеВремя(ОписаниеИДанные.Дата, ТекущийЧасовойПояс) - '19700101';
		БуферЗаголовка.ЗаписатьЦелое32(4, ДатаЧислом);
		БуферЗаголовка[8] = 0; // флаги степени сжатия
		БуферЗаголовка[9] = 0; // для Linux можно указать 3
		
		Если ЗначениеЗаполнено(ОписаниеИДанные.ИмяФайла) Тогда
			БуферЗаголовка.Записать(10, БуферИмениФайла, ДлинаИмениФайла - 1);
			БуферЗаголовка[9 + ДлинаИмениФайла] = 0;
		КонецЕсли;
		
		ЗаписьДанныхGzip.ЗаписатьБуферДвоичныхДанных(БуферЗаголовка);
		
		ЗаписьДанныхGzip.ЗаписатьБуферДвоичныхДанных(ОписаниеИДанные.УпакованныеДанные);
		
		БуферЗавершения = Новый БуферДвоичныхДанных(8);
		БуферЗавершения.ЗаписатьЦелое32(0, ОписаниеИДанные.КонтрольнаяСумма);
		БуферЗавершения.ЗаписатьЦелое32(4, ОписаниеИДанные.ДлинаРаспакованныхДанных);
		
		ЗаписьДанныхGzip.ЗаписатьБуферДвоичныхДанных(БуферЗавершения);
	КонецЦикла;
	
	ЗаписьДанныхGzip.Закрыть();
	
КонецПроцедуры

// Возвращает массив с описаниями и данными файлов внутри архива gzip (формат обычно используется для сжатия одного
// файла).
//
// Параметры:
//  ИмяФайлаПотокИлиДвоичныеДанные - Строка, Поток, ДвоичныеДанные - gzip-архив.
//  ВозвращатьМассивПриОшибке      - Булево - возвращать массив прочитанной информации о файлах, если формат
//                                   последнего файла некорректный и количество корректных файлов больше нуля.
//  ИмяФайлаПоУмолчанию            - Строка - имя файла, возвращаемое, если имя файла в gzip-архиве не задано.
//
// Возвращаемое значение:
//  Массив       - информация о файлах в архиве.
//    * ФорматНеПоддерживается   - Булево - формат файла некорректный, обработка на этом файле прекращается.
//    * Версия                   - Число.
//    * МетодСжатия              - Число - 8 - Deflate.
//    * Дата                     - Дата.
//    * КонтрольнаяСумма         - Число.
//    * ДлинаРаспакованныхДанных - Число.
//    * ИмяФайла                 - Строка - может быть не задано, тогда заполняется из ИмяФайлаПоУмолчанию.
//    * УпакованныеДанные        - БуферДвоичныхДанных.
//    * Комментарий              - Строка.
//  Неопределено - формат последнего файла некорректный и значение параметра ВозвращатьМассивПриОшибке равно Ложь
//                 либо архив не содержит корректных файлов.
//
Функция МассивОписанийИДанныхGzipФайла(ИмяФайлаПотокИлиДвоичныеДанные, ВозвращатьМассивПриОшибке = Ложь,
		ИмяФайлаПоУмолчанию = "file") Экспорт
	
	Результат = Новый Массив;
	
	ОбъектЧтениеДанных = Новый ЧтениеДанных(ИмяФайлаПотокИлиДвоичныеДанные);
	ПоляИДанныеGzip = Неопределено;
	ТекущийЧасовойПояс = ЧасовойПоясСеанса();
	ДатаСеанса = ТекущаяДатаСеанса();
	ПоправкаКВремени = УниверсальноеВремя(ДатаСеанса, ТекущийЧасовойПояс) - ДатаСеанса;
	
	Пока Истина Цикл
		ИнформацияОФайле = Новый Структура;
		ИнформацияОФайле.Вставить("ФорматНеПоддерживается", 	Ложь);
		ИнформацияОФайле.Вставить("Версия", 					Неопределено);
		ИнформацияОФайле.Вставить("МетодСжатия", 				Неопределено);
		ИнформацияОФайле.Вставить("Дата", 						Неопределено);
		ИнформацияОФайле.Вставить("КонтрольнаяСумма", 			Неопределено);
		ИнформацияОФайле.Вставить("ДлинаРаспакованныхДанных", 	Неопределено);
		ИнформацияОФайле.Вставить("ИмяФайла", 					Неопределено);
		ИнформацияОФайле.Вставить("УпакованныеДанные", 			Неопределено);
		ИнформацияОФайле.Вставить("Комментарий", 				Неопределено);
		
		Если ПоляИДанныеGzip = Неопределено Тогда
			ЗаголовокGzip = ОбъектЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(10);
		Иначе
			ЗаголовокGzip = ПоляИДанныеGzip.ПолучитьСрез(0, ?(ПоляИДанныеGzip.Размер >= 10, 10, ПоляИДанныеGzip.Размер));
		КонецЕсли;
		
		Если ЗаголовокGzip.Размер < 10
			ИЛИ ЗаголовокGzip[0] <> 31 ИЛИ ЗаголовокGzip[1] <> 139 Тогда
			
			ИнформацияОФайле.ФорматНеПоддерживается = Истина;
			Результат.Добавить(ИнформацияОФайле);
			Прервать;
		КонецЕсли;
		
		ИнформацияОФайле.МетодСжатия = ЗаголовокGzip[2];
		ФлагиСжатия = ЗаголовокGzip[3];
		ИнформацияОФайле.Дата = '19700101' + ЗаголовокGzip.ПрочитатьЦелое32(4) - ПоправкаКВремени;
		ЭтоLinux = (ЗаголовокGzip[9] = 3);
		
		ЕстьCRC16 			= (ПобитовоеИ(ФлагиСжатия, 2) = 2);
		ЕстьРасширенноеПоле = (ПобитовоеИ(ФлагиСжатия, 4) = 4);
		ЕстьИмяФайла 		= (ПобитовоеИ(ФлагиСжатия, 8) = 8);
		ЕстьКомментарий 	= (ПобитовоеИ(ФлагиСжатия, 16) = 16);
		
		Если ПоляИДанныеGzip = Неопределено Тогда
			ПоляИДанныеGzip = ОбъектЧтениеДанных.ПрочитатьВБуферДвоичныхДанных();
		Иначе
			ПоляИДанныеGzip = ?(ПоляИДанныеGzip.Размер > 10, ПоляИДанныеGzip.ПолучитьСрез(10), Новый БуферДвоичныхДанных(0));
		КонецЕсли;
		
		Если ЕстьРасширенноеПоле Тогда
			Если ПоляИДанныеGzip.Размер < 2 Тогда
				ИнформацияОФайле.ФорматНеПоддерживается = Истина;
				Результат.Добавить(ИнформацияОФайле);
				Прервать;
			КонецЕсли;
			
			ДлинаРасширенногоПоля = ПоляИДанныеGzip.ПрочитатьЦелое16(0);
			ПоляИДанныеGzip = ?(2 + ДлинаРасширенногоПоля < ПоляИДанныеGzip.Размер,
				ПоляИДанныеGzip.ПолучитьСрез(2 + ДлинаРасширенногоПоля), Новый БуферДвоичныхДанных(0));
		КонецЕсли;
		
		Если ЕстьИмяФайла Тогда
			ПозицияКонца = НайтиВБуфереДвоичныхДанных(ПоляИДанныеGzip, "00");
			Если ПозицияКонца = Неопределено Тогда
				ИнформацияОФайле.ФорматНеПоддерживается = Истина;
				Результат.Добавить(ИнформацияОФайле);
				Прервать;
			КонецЕсли;
			
			БуферИмениФайла = ?(ПозицияКонца > 0, ПоляИДанныеGzip.ПолучитьСрез(0, ПозицияКонца), Новый БуферДвоичныхДанных(0));
			ПотокИмениФайла = Новый ПотокВПамяти(БуферИмениФайла);
			ДанныеИмениФайла = ПотокИмениФайла.ЗакрытьИПолучитьДвоичныеДанные();
			ИнформацияОФайле.ИмяФайла = ПолучитьСтрокуИзДвоичныхДанных(ДанныеИмениФайла, ?(ЭтоLinux, "utf-8", "windows-1251"));
			
			ПоляИДанныеGzip = ?(ПозицияКонца + 1 < ПоляИДанныеGzip.Размер, ПоляИДанныеGzip.ПолучитьСрез(ПозицияКонца + 1),
				Новый БуферДвоичныхДанных(0));
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ИнформацияОФайле.ИмяФайла) Тогда
			ИнформацияОФайле.ИмяФайла = ИмяФайлаПоУмолчанию;
		КонецЕсли;
		
		Если ЕстьКомментарий Тогда
			ПозицияКонца = НайтиВБуфереДвоичныхДанных(ПоляИДанныеGzip, "00");
			Если ПозицияКонца = Неопределено Тогда
				ИнформацияОФайле.ФорматНеПоддерживается = Истина;
				Результат.Добавить(ИнформацияОФайле);
				Прервать;
			КонецЕсли;
			
			БуферКомментария = ?(ПозицияКонца > 0, ПоляИДанныеGzip.ПолучитьСрез(0, ПозицияКонца), Новый БуферДвоичныхДанных(0));
			ПотокКомментария = Новый ПотокВПамяти(БуферКомментария);
			ДанныеКомментария = ПотокКомментария.ЗакрытьИПолучитьДвоичныеДанные();
			ИнформацияОФайле.Комментарий = ПолучитьСтрокуИзДвоичныхДанных(ДанныеКомментария,
				?(ЭтоLinux, "utf-8", "windows-1251"));
			
			ПоляИДанныеGzip = ?(ПозицияКонца + 1 < ПоляИДанныеGzip.Размер, ПоляИДанныеGzip.ПолучитьСрез(ПозицияКонца + 1),
				Новый БуферДвоичныхДанных(0));
		КонецЕсли;
		
		Если ЕстьCRC16 Тогда
			Если ПоляИДанныеGzip.Размер < 2 Тогда
				ИнформацияОФайле.ФорматНеПоддерживается = Истина;
				Результат.Добавить(ИнформацияОФайле);
				Прервать;
			КонецЕсли;
			
			ПоляИДанныеGzip = ?(2 < ПоляИДанныеGzip.Размер, ПоляИДанныеGzip.ПолучитьСрез(2), Новый БуферДвоичныхДанных(0));
		КонецЕсли;
		
		ПозицияКонца = НайтиВБуфереДвоичныхДанных(ПоляИДанныеGzip, "1F8B0808"); // след.файлы поддерживаем только с именем
		Если ПозицияКонца = Неопределено Тогда
			ПозицияКонца = ПоляИДанныеGzip.Размер;
		КонецЕсли;
		
		Если ПозицияКонца < 8 Тогда
			ИнформацияОФайле.ФорматНеПоддерживается = Истина;
			Результат.Добавить(ИнформацияОФайле);
			Прервать;
		КонецЕсли;
		
		ИнформацияОФайле.УпакованныеДанные = ?(ПозицияКонца > 8, ПоляИДанныеGzip.ПолучитьСрез(0, ПозицияКонца - 8),
			Новый БуферДвоичныхДанных(0));
		ИнформацияОФайле.КонтрольнаяСумма = ПоляИДанныеGzip.ПрочитатьЦелое32(ПозицияКонца - 8);
		ИнформацияОФайле.ДлинаРаспакованныхДанных = ПоляИДанныеGzip.ПрочитатьЦелое32(ПозицияКонца - 4);
		
		Результат.Добавить(ИнформацияОФайле);
		
		Если ПозицияКонца >= ПоляИДанныеGzip.Размер Тогда
			Прервать;
		КонецЕсли;
		
		ПоляИДанныеGzip = ПоляИДанныеGzip.ПолучитьСрез(ПозицияКонца);
	КонецЦикла;
	
	ОбъектЧтениеДанных.Закрыть();
	
	Если Результат.Количество() = 0
		ИЛИ Результат.Количество() = 1 И Результат[0].ФорматНеПоддерживается
		ИЛИ НЕ ВозвращатьМассивПриОшибке И Результат[Результат.Количество() - 1].ФорматНеПоддерживается Тогда
		
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// По описаниям и данным файлов записывает архив zip.
//
//  МассивОписанийИДанных - Массив - информация о файлах в архиве.
//    * МетодСжатия              - Число - 8 - Deflate.
//    * Дата                     - Дата.
//    * КонтрольнаяСумма         - Число.
//    * ДлинаРаспакованныхДанных - Число.
//    * ИмяФайла                 - Строка.
//    * УпакованныеДанные        - БуферДвоичныхДанных.
//  ИмяФайлаИлиПоток      - Строка, Поток - файл для сохранения gzip-архива.
//  КодировкаИменФайлов   - Строка - "cp866", свойственная более ранним версиям zip, или "utf-8", используемая
//                          по умолчанию объектами платформы "ЧтениеZipФайла" и "ЗаписьZipФайла".
//
Процедура СформироватьZip(МассивОписанийИДанных, ИмяФайлаИлиПоток, КодировкаИменФайлов = "utf-8") Экспорт
	
	ЗаписьДанныхZip = Новый ЗаписьДанных(ИмяФайлаИлиПоток);
	СмещениеОсновногоКаталога = 0;
	РазмерОсновногоКаталога = 0;
	КоличествоФайлов = МассивОписанийИДанных.Количество();
	СмещенияОписаний = Новый Массив;
	ДатыЧислом = Новый Массив;
	ЭтоКодировкаUTF8 = (КодировкаИменФайлов = КодировкаТекста.UTF8
		ИЛИ ТипЗнч(КодировкаИменФайлов) = Тип("Строка") И нрег(КодировкаИменФайлов) = "utf-8");
	
	Для каждого ОписаниеИДанные Из МассивОписанийИДанных Цикл
		ДлинаИмениФайла = 0;
		Если ЗначениеЗаполнено(ОписаниеИДанные.ИмяФайла) Тогда
			БуферИмениФайла = ПолучитьБуферДвоичныхДанныхИзСтроки(ОписаниеИДанные.ИмяФайла, КодировкаИменФайлов);
			ДлинаИмениФайла = БуферИмениФайла.Размер;
		КонецЕсли;
		
		ЗаголовокZip1 = Новый БуферДвоичныхДанных(30 + ДлинаИмениФайла);
		
		ЗаголовокZip1[0] = КодСимвола("P"); // ID
		ЗаголовокZip1[1] = КодСимвола("K"); // ID
		ЗаголовокZip1[2] = 3; // ID
		ЗаголовокZip1[3] = 4; // ID
		ЗаголовокZip1[4] = ?(ЭтоКодировкаUTF8, 20, 10); // версия
		ЗаголовокZip1[5] = 0; // операционная система
		ЗаголовокZip1.ЗаписатьЦелое16(6, ?(ЭтоКодировкаUTF8, 8 * 256, 0)); // флаги кодирования имени файла в utf-8
		ЗаголовокZip1.ЗаписатьЦелое16(8, ОписаниеИДанные.МетодСжатия);
		ГодДаты = Год(ОписаниеИДанные.Дата);
		ДатаЧислом = ((?(ГодДаты < 1980 ИЛИ ГодДаты > 2107, 2000 + ГодДаты % 100, ГодДаты) - 1980) * 512
			+ Месяц(ОписаниеИДанные.Дата) * 32 + День(ОписаниеИДанные.Дата)) * 65536
			+ Час(ОписаниеИДанные.Дата) * 2048 + Минута(ОписаниеИДанные.Дата) * 32 + Секунда(ОписаниеИДанные.Дата) % 2;
		ДатыЧислом.Добавить(ДатаЧислом);
		ЗаголовокZip1.ЗаписатьЦелое32(10, ДатаЧислом);
		ЗаголовокZip1.ЗаписатьЦелое32(14, ОписаниеИДанные.КонтрольнаяСумма);
		ЗаголовокZip1.ЗаписатьЦелое32(18, ОписаниеИДанные.УпакованныеДанные.Размер);
		ЗаголовокZip1.ЗаписатьЦелое32(22, ОписаниеИДанные.ДлинаРаспакованныхДанных);
		ЗаголовокZip1.ЗаписатьЦелое16(26, ДлинаИмениФайла);
		ЗаголовокZip1.ЗаписатьЦелое16(28, 0); // длина дополнительных блоков
		
		Если ЗначениеЗаполнено(ОписаниеИДанные.ИмяФайла) Тогда
			ЗаголовокZip1.Записать(30, БуферИмениФайла, ДлинаИмениФайла);
		КонецЕсли;
		
		ЗаписьДанныхZip.ЗаписатьБуферДвоичныхДанных(ЗаголовокZip1);
		
		ЗаписьДанныхZip.ЗаписатьБуферДвоичныхДанных(ОписаниеИДанные.УпакованныеДанные);
		
		СмещениеОсновногоКаталога = СмещениеОсновногоКаталога + ЗаголовокZip1.Размер
			+ ОписаниеИДанные.УпакованныеДанные.Размер;
		Если СмещенияОписаний.Количество() < КоличествоФайлов - 1 Тогда
			СмещенияОписаний.Добавить(СмещениеОсновногоКаталога);
		КонецЕсли;
	КонецЦикла;
	
	ИндексФайла = 0;
	Для каждого ОписаниеИДанные Из МассивОписанийИДанных Цикл
		ДлинаИмениФайла = 0;
		Если ЗначениеЗаполнено(ОписаниеИДанные.ИмяФайла) Тогда
			БуферИмениФайла = ПолучитьБуферДвоичныхДанныхИзСтроки(ОписаниеИДанные.ИмяФайла, КодировкаИменФайлов);
			ДлинаИмениФайла = БуферИмениФайла.Размер;
		КонецЕсли;
		
		ЗаголовокZip2 = Новый БуферДвоичныхДанных(46 + ДлинаИмениФайла);
		
		ЗаголовокZip2[0] = КодСимвола("P"); // ID
		ЗаголовокZip2[1] = КодСимвола("K"); // ID
		ЗаголовокZip2[2] = 1; // ID
		ЗаголовокZip2[3] = 2; // ID
		ЗаголовокZip2[4] = ?(ЭтоКодировкаUTF8, 46, 63); // версия распаковки
		ЗаголовокZip2[5] = 0; // операционная система упаковки
		ЗаголовокZip2[6] = ?(ЭтоКодировкаUTF8, 20, 10); // версия распаковки
		ЗаголовокZip2[7] = 0; // операционная система распаковки
		ЗаголовокZip2.ЗаписатьЦелое16(8, ?(ЭтоКодировкаUTF8, 8 * 256, 0)); // флаги кодирования имени файла в utf-8
		ЗаголовокZip2.ЗаписатьЦелое16(10, ОписаниеИДанные.МетодСжатия);
		ЗаголовокZip2.ЗаписатьЦелое32(12, ДатыЧислом[ИндексФайла]);
		ЗаголовокZip2.ЗаписатьЦелое32(16, ОписаниеИДанные.КонтрольнаяСумма);
		ЗаголовокZip2.ЗаписатьЦелое32(20, ОписаниеИДанные.УпакованныеДанные.Размер);
		ЗаголовокZip2.ЗаписатьЦелое32(24, ОписаниеИДанные.ДлинаРаспакованныхДанных);
		ЗаголовокZip2.ЗаписатьЦелое16(28, ДлинаИмениФайла);
		ЗаголовокZip2.ЗаписатьЦелое16(30, 0); // длина дополнительных блоков
		ЗаголовокZip2.ЗаписатьЦелое16(32, 0); // комментарий
		ЗаголовокZip2.ЗаписатьЦелое16(34, 0); // номер диска
		ЗаголовокZip2.ЗаписатьЦелое16(36, 0); // атрибуты Zip
		ЗаголовокZip2.ЗаписатьЦелое32(38, 32); // атрибуты
		ЗаголовокZip2.ЗаписатьЦелое32(42, ?(ИндексФайла > 0, СмещенияОписаний[ИндексФайла - 1], 0)); // смещение
		
		Если ЗначениеЗаполнено(ОписаниеИДанные.ИмяФайла) Тогда
			ЗаголовокZip2.Записать(46, БуферИмениФайла, ДлинаИмениФайла);
		КонецЕсли;
		
		ЗаписьДанныхZip.ЗаписатьБуферДвоичныхДанных(ЗаголовокZip2);
		
		РазмерОсновногоКаталога = РазмерОсновногоКаталога + ЗаголовокZip2.Размер;
		ИндексФайла = ИндексФайла + 1;
	КонецЦикла;
	
	ОсновнойКаталогZip = Новый БуферДвоичныхДанных(22);
	ОсновнойКаталогZip[0] = КодСимвола("P"); // ID
	ОсновнойКаталогZip[1] = КодСимвола("K"); // ID
	ОсновнойКаталогZip[2] = 5; // ID
	ОсновнойКаталогZip[3] = 6; // ID
	ОсновнойКаталогZip.ЗаписатьЦелое16(4, 0); // номер текущего диска
	ОсновнойКаталогZip.ЗаписатьЦелое16(6, 0); // номер диска основного каталога
	ОсновнойКаталогZip.ЗаписатьЦелое16(8, КоличествоФайлов); // количество записей основного каталога на диске
	ОсновнойКаталогZip.ЗаписатьЦелое16(10, КоличествоФайлов); // общее количество записей основного каталога
	ОсновнойКаталогZip.ЗаписатьЦелое32(12, РазмерОсновногоКаталога);
	ОсновнойКаталогZip.ЗаписатьЦелое32(16, СмещениеОсновногоКаталога); // смещение каталога
	ОсновнойКаталогZip.ЗаписатьЦелое16(20, 0); // длина комментария
	ЗаписьДанныхZip.ЗаписатьБуферДвоичныхДанных(ОсновнойКаталогZip);
	
	ЗаписьДанныхZip.Закрыть();
	
КонецПроцедуры

// Поиск строки в буфере двоичных данных.
//
// Параметры:
//  Буфер      - БуферДвоичныхДанных - буфер для поиска.
//  СтрокаВHex - Строка - строка шестнадцатеричных символов.
//
// Возвращаемое значение:
//  Число        - индекс первой строки.
//  Неопределено - если строка не найдена в буфере.
Функция НайтиВБуфереДвоичныхДанных(Буфер, СтрокаВHex) Экспорт
	
	Результат = Неопределено;
	
	ПозицияБуфера = 0;
	БуферВHex = ПолучитьHexСтрокуИзБуфераДвоичныхДанных(Буфер);
	
	Пока Истина Цикл
		ПозицияСтроки = СтрНайти(БуферВHex, СтрокаВHex);
		Если ПозицияСтроки = 0 Тогда
			Прервать;
		КонецЕсли;
		
		ЭтоПозицияНачалаБайта = ((ПозицияСтроки - 1) % 2 = 0);
		
		Если ЭтоПозицияНачалаБайта Тогда
			Результат = ПозицияБуфера + (ПозицияСтроки - 1) / 2;
			Прервать;
		КонецЕсли;
		
		ПозицияБуфера = ПозицияБуфера + ПозицияСтроки / 2;
		БуферВHex = Сред(БуферВHex, ПозицияСтроки + 1);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти