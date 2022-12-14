// Общий модуль (выполняется на стороне сервера) модуля "Конструктор процессов для 1С:УНФ"
// Разработчик Компания "Аналитика. Проекты и решения" +7 495 005-1653, https://kp-unf.ru

#Область СлужебныеПроцедурыИФункции

// Функция возвращает выборку из подчиненного справочника набора областей шаблона файла
// Параметры:
//		ФайлСсылка - ссылка на файл
// Возвращаемое значение: Выборка из запроса
Функция ПолучитьВыборкуОбластейШаблона(ФайлСсылка) Экспорт
	
	Запрос=Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
								|	КП_ОбластиШаблоновФайлов.Наименование,
								|	КП_ОбластиШаблоновФайлов.ТипОбласти
								|ИЗ
								|	Справочник.КП_ОбластиШаблоновФайлов КАК КП_ОбластиШаблоновФайлов
								|ГДЕ
								|	КП_ОбластиШаблоновФайлов.ПометкаУдаления = ЛОЖЬ
								|	И КП_ОбластиШаблоновФайлов.Владелец = &Файл
								|	И КП_ОбластиШаблоновФайлов.Отключено = ЛОЖЬ");
	Запрос.УстановитьПараметр("Файл", ФайлСсылка);
	ВыборкаОбласти=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	Возврат ВыборкаОбласти;
	
КонецФункции

// Функция возвращает расширение файла без точки
// Параметры:
// 	СтрРасширение - Строка расширения
// Возвращаемое значение: Строка
Функция РасширениеБезТочки(СтрРасширение) Экспорт
	Расширение = НРег(СокрЛП(СтрРасширение));
	Если Сред(Расширение, 1, 1) = "." Тогда
		Расширение = Сред(Расширение, 2);
	КонецЕсли;
	Возврат Расширение;
	
КонецФункции 

// Функция создает файл у указанного владельца
// Параметры:
// 	ПутьКФайлу - Путь к файлу
// 	ВладелецФайла - Владелец файла
// Возвращаемое значение: Ссылка на файл
Функция СоздатьФайлВладельца(ПутьКФайлу, ВладелецФайла) Экспорт
	
	Файл=Новый Файл(ПутьКФайлу);
	ВремяИзменения = Файл.ПолучитьВремяИзменения();
	ВремяИзмененияУниверсальное = Файл.ПолучитьУниверсальноеВремяИзменения();
	
	АдресВременногоХранилищаТекста = "";
	АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлу));
	
	НовыйФайл=РаботаСФайламиСлужебныйВызовСервера.СоздатьФайлСВерсией(
		ВладелецФайла,
		Файл.ИмяБезРасширения,
		КП_РаботаСФайлами.РасширениеБезТочки(Файл.Расширение),
		ВремяИзменения,
		ВремяИзмененияУниверсальное,
		Файл.Размер(),
		АдресВременногоХранилищаФайла,
		АдресВременногоХранилищаТекста,
		Ложь); // это не веб клиент
		
	Возврат НовыйФайл;
	
КонецФункции

// Функция создает файл владельца по двоичным данным
// Параметры:
// 	ИмяФайла - Имя файла
// 	ДвоичныеДанныеФайла - Двоичные данные файла
// 	ВладелецФайла - Владелец файла
// 	РазмерФайла - Размер файла
// Возвращаемое значение: Двоичные данные
Функция СоздатьФайлВладельцаПоДвоичнымДанным(ИмяФайла, ДвоичныеДанныеФайла, ВладелецФайла, РазмерФайла=0) Экспорт
	
	//получим расширение файла из имени файла
	РасширениеФайла=КП_ОбщееСервер.ПолучитьПравуюЧастьСтрокиОтделеннойСимволом(ИмяФайла, ".");
	
	ИмяБезРасширения=СтрЗаменить(ИмяФайла, "."+РасширениеФайла, "");
	
	ВремяИзменения = ТекущаяДата();
	ВремяИзмененияУниверсальное =  ТекущаяДата();
	
	АдресВременногоХранилищаТекста = "";
	АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
	
	//НовыйФайл=РаботаСФайламиСлужебныйВызовСервера.СоздатьФайлСВерсией(
	НовыйФайл=РаботаСФайламиСлужебныйВызовСервера.СоздатьФайлСВерсией(
		ВладелецФайла,
		ИмяБезРасширения,
		РасширениеФайла,
		ВремяИзменения,
		ВремяИзмененияУниверсальное,
		РазмерФайла,
		АдресВременногоХранилищаФайла,
		АдресВременногоХранилищаТекста,
		Ложь // это не веб клиент
		);
		
	Возврат НовыйФайл;
	
КонецФункции

// Функция формирует и возвращает xml-текст шаблона файла
// Параметры:
//		ШаблонФайла - шаблона файла
// Возвращаемое значение: Строка с XML
Функция ПолучитьXMLШаблонаФайл(ШаблонФайла) Экспорт
	
	ВерсияФайла=1.1;
	
	ЗаписьXML=Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку(); //вывод будет идти в строку, а не файл
	
	СтрокаДаты=Формат(ТекущаяДата(), "ДЛФ=DDT");
	СтрокаВерсии=СокрЛП(ВерсияФайла);
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Выгрузка шаблона файла: ';")+СокрЛП(ШаблонФайла.Наименование));
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Версия файла: ';")+Формат(ВерсияФайла, "ЧДЦ=2; ЧРД=."));
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Дата: ';")+СтрокаДаты);	
	
	ИнформацияОСистеме=Новый СистемнаяИнформация;
	СтрокаВерсииПлатформы=СокрЛП(ИнформацияОСистеме.ВерсияПриложения);
	СтрокаРелиза=СокрЛП(Метаданные.Версия);
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("root");
	ЗаписьXML.ЗаписатьАтрибут("webLibrary", "документооборот.net");
	ЗаписьXML.ЗаписатьАтрибут("type", "template_file");
	ЗаписьXML.ЗаписатьАтрибут("version", СтрокаВерсии);
	ЗаписьXML.ЗаписатьАтрибут("platform", СтрокаВерсииПлатформы);
	ЗаписьXML.ЗаписатьАтрибут("release", СтрокаРелиза);
	ЗаписьXML.ЗаписатьАтрибут("date", СтрокаДаты);
	ЗаписьXML.ЗаписатьАтрибут("name", СокрЛП(ШаблонФайла.Наименование));
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("template_filedata");

	Попытка
		ЗаписатьXML(ЗаписьXML, ШаблонФайла.Ссылка.ПолучитьОбъект());
		
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		Возврат "";
		
	КонецПопытки;
	
	ЗаписьXML.ЗаписатьКонецЭлемента(); //template_filedata
	
	//запишем области макета
	
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_ОбластиШаблоновФайлов.Ссылка
	                    |ИЗ
	                    |	Справочник.КП_ОбластиШаблоновФайлов КАК КП_ОбластиШаблоновФайлов
	                    |ГДЕ
	                    |	КП_ОбластиШаблоновФайлов.ПометкаУдаления = ЛОЖЬ
	                    |	И КП_ОбластиШаблоновФайлов.Владелец = &Владелец");
						
	Запрос.УстановитьПараметр("Владелец", ШаблонФайла);
						
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	Если Выборка.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Области макета:';en='Layout area:'"));
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		ОбластьШаблона=Выборка.Ссылка;
		
		//добавим сериализацию области
		ЗаписьXML.ЗаписатьНачалоЭлемента("template_region");
		ЗаписатьXML(ЗаписьXML, ОбластьШаблона.Ссылка.ПолучитьОбъект());
		ЗаписьXML.ЗаписатьКонецЭлемента(); //template_region
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='   ';")+СокрЛП(ОбластьШаблона));
		
	КонецЦикла;
	
	//запишем параметры шаблона
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_ПараметрыШаблоновФайлов.Ссылка
	                    |ИЗ
	                    |	Справочник.КП_ПараметрыШаблоновФайлов КАК КП_ПараметрыШаблоновФайлов
	                    |ГДЕ
	                    |	КП_ПараметрыШаблоновФайлов.ПометкаУдаления = ЛОЖЬ
	                    |	И КП_ПараметрыШаблоновФайлов.Владелец = &Владелец");
						
	Запрос.УстановитьПараметр("Владелец", ШаблонФайла);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	Если Выборка.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Параметры шаблона:';en='Template parameters:'"));
	КонецЕсли;

   	Пока Выборка.Следующий() Цикл
		
		ПараметрШаблона=Выборка.Ссылка;
		ИсточникДанных=ПараметрШаблона.ИсточникДанных;
		
		ВыбранныйИсточникДанных=ИсточникДанных;
		Пока ЗначениеЗаполнено(ВыбранныйИсточникДанных) Цикл
			//добавим сериализацию источника данных основания
			ЗаписьXML.ЗаписатьНачалоЭлемента("template_datasource");
			ЗаписатьXML(ЗаписьXML, ВыбранныйИсточникДанных.Ссылка.ПолучитьОбъект());
			ЗаписьXML.ЗаписатьКонецЭлемента(); //template_datasource
			
			Если ЗначениеЗаполнено(ВыбранныйИсточникДанных.ФункцияПолученияДанных) Тогда
				//добавим сериализацию функции получения данных
				ЗаписьXML.ЗаписатьНачалоЭлемента("template_datafunction");
				ФункцияПолученияДанных=ВыбранныйИсточникДанных.ФункцияПолученияДанных;
				ЗаписатьXML(ЗаписьXML, ФункцияПолученияДанных.Ссылка.ПолучитьОбъект());
				ЗаписьXML.ЗаписатьКонецЭлемента(); //template_datafunction
			КонецЕсли;
			
			ВыбранныйИсточникДанных=ВыбранныйИсточникДанных.ИсточникДанныхОснование;
			
		КонецЦикла;
			
		//добавим сериализацию параметра
		ЗаписьXML.ЗаписатьНачалоЭлемента("template_params");
		ЗаписатьXML(ЗаписьXML, ПараметрШаблона.Ссылка.ПолучитьОбъект());
		ЗаписьXML.ЗаписатьКонецЭлемента(); //template_params
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='   ';")+СокрЛП(ПараметрШаблона));
		
	КонецЦикла;
	
	//сохраним сам файл (текущую версию)
	ЗаписьXML.ЗаписатьНачалоЭлемента("template_fileCurrentVersion");
	
	Попытка
		ЗаписатьXML(ЗаписьXML, ШаблонФайла.Ссылка.ТекущаяВерсия.ПолучитьОбъект());
		
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		Возврат "";
		
	КонецПопытки;
	
	ЗаписьXML.ЗаписатьКонецЭлемента(); //template_fileCurrentVersion

	ЗаписьXML.ЗаписатьКонецЭлемента(); //root

	ТекстXML=ЗаписьXML.Закрыть();
	
	Возврат ТекстXML;
	
	Возврат "";
	
КонецФункции

// Функция выполняет чтение и запись шаблона файла из файла формата bpl
// Параметры:
//		ПутьКФайлу - содержит строку с путем к файлу из которого нужно произвести чтение
// Возвращаемое значение: Ссылка на прочитанный вид процесса или Неопределено
Функция ПрочитатьШаблонФайлаXML(СтрокаXML) Экспорт
	
	МинимальноДопустимаяВерсияФайла=5.0;
	ДатаИзмененияВерсии=Дата("20140601");
		
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	ЗагруженныйШаблонФайла=Неопределено;
	
	Пока ЧтениеXML.Прочитать() Цикл

		ИмяУзла=ЧтениеXML.ЛокальноеИмя;
		Если ИмяУзла="root" И ЧтениеXML.ТипУзла=ТипУзлаXML.НачалоЭлемента Тогда
			
			СтрокаТипа=ЧтениеXML.ПолучитьАтрибут("type");
			Если СтрокаТипа<>"template_file" Тогда
				
				СтрокаСообщения="Внимание! Файл не содержит данных о шаблоне файла.";
				СтрокаСообщения=СтрокаСообщения+" "+КП_ОбщееСерверПС.ПолучитьСообщениеОТипеBPLФайла(СтрокаТипа);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения+НСтр("ru=' Чтение не произведено.';"));
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			//прочитаем аттрибуты корневого элемента
			СтрокаВерсии=ЧтениеXML.ПолучитьАтрибут("version");
			
			Если СтрокаВерсии=Неопределено ИЛИ ПустаяСтрока(СтрокаВерсии) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не найдена версия файла! Загрузка не произведена.';en='File version is not found! Nothing done.'"));
				Возврат Неопределено;
			КонецЕсли;
			
			ВерсияФайла=Число(СтрокаВерсии);
			Если ВерсияФайла<МинимальноДопустимаяВерсияФайла Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Версия файла ';")+Формат(ВерсияФайла, "ЧДЦ=2; ЧРД=.")+НСтр("ru=' ниже чем необходимая (';")+Формат(МинимальноДопустимаяВерсияФайла, "ЧДЦ=2; ЧРД=.")+НСтр("ru='). Файл был сформирован до ';")+Формат(ДатаИзмененияВерсии, "ДФ=dd.MM.yyyy")+НСтр("ru='. Загрузка не произведена.';en='. Nothing was done.'"));
				Возврат Неопределено;
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Версия файла ';")+Формат(ВерсияФайла, "ЧДЦ=2; ЧРД=."));
			
			СтрокаДаты=ЧтениеXML.ПолучитьАтрибут("date");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Дата: ';")+СокрЛП(СтрокаДаты));
			
			СтрокаНаименования=ЧтениеXML.ПолучитьАтрибут("name");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Загрузка шаблона файла: ';")+СокрЛП(СтрокаНаименования));

			//перейдем к следующим элементам
			Продолжить;
			
		ИначеЕсли ИмяУзла="template_fileCurrentVersion" Тогда
			//прочитаем текущую версию файла
			
			ЧтениеXML.Прочитать();
			
			Попытка 
				Если ВозможностьЧтенияXML(ЧтениеXML) Тогда
				    ВерсияФайла = ПрочитатьXML(ЧтениеXML);
					Если НЕ ЗначениеЗаполнено(ВерсияФайла.Автор) ИЛИ Найти(ВерсияФайла.Автор, "Объект не найден")>0 Тогда
						ВерсияФайла.Автор=Пользователи.ТекущийПользователь();
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Автором текущей версии установлен текущий пользователь';en='The author of the current version of the current user set'"));
					КонецЕсли;
    				ВерсияФайла.Записать();
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='  Текущая версия файла: ';")+СокрЛП(ВерсияФайла));
					
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Чтение текущей версии файла не возможно.';en='Read the current version of a file is not possible.'"));
					Возврат Неопределено;
					
				КонецЕсли;
				
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				Возврат Неопределено;
		
			КонецПопытки;
			
		
		ИначеЕсли ИмяУзла="template_filedata" Тогда
	        //прочитаем файл
			
			ЧтениеXML.Прочитать();
			
			Попытка 
				Если ВозможностьЧтенияXML(ЧтениеXML) Тогда
				    ЗагруженныйШаблонФайла=ПрочитатьXML(ЧтениеXML);
					Если НЕ ЗначениеЗаполнено(ЗагруженныйШаблонФайла.Автор) ИЛИ Найти(ЗагруженныйШаблонФайла.Автор, "Объект не найден")>0 Тогда
						ЗагруженныйШаблонФайла.Автор=Пользователи.ТекущийПользователь();
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Автором файла установлен текущий пользователь';en='The author of the file is set the current user'"));
					КонецЕсли;
					
					Если НЕ ЗначениеЗаполнено(ЗагруженныйШаблонФайла.ТекущаяВерсияАвтор) ИЛИ Найти(ЗагруженныйШаблонФайла.ТекущаяВерсияАвтор, "Объект не найден")>0 Тогда
						ЗагруженныйШаблонФайла.ТекущаяВерсияАвтор=ЗагруженныйШаблонФайла.Автор;
					КонецЕсли;
					Если Найти(ЗагруженныйШаблонФайла.Родитель, "Объект не найден")>0 Тогда
						ЗагруженныйШаблонФайла.Родитель=Справочники.Файлы.ПустаяСсылка();
					КонецЕсли;
    				ЗагруженныйШаблонФайла.Записать();	
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Чтение шаблона файла не возможно.';en='Reading a file template is not possible.'"));
					Возврат Неопределено;
					
				КонецЕсли;
				
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				Возврат Неопределено;
		
			КонецПопытки;
			
		ИначеЕсли ИмяУзла="template_region" Тогда
			//прочитаем области шаблона
			
			ЧтениеXML.Прочитать();
			
			Попытка 
				Если ВозможностьЧтенияXML(ЧтениеXML) Тогда
				    ОбластьШаблона = ПрочитатьXML(ЧтениеXML);
    				ОбластьШаблона.Записать();
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='  Область шаблона: ';")+СокрЛП(ОбластьШаблона));
					
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Чтение области шаблона не возможно.';en='Reading area of the template is not possible.'"));
					Возврат Неопределено;
					
				КонецЕсли;
				
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				Возврат Неопределено;
		
			КонецПопытки;
			
		ИначеЕсли ИмяУзла="template_datasource" Тогда
			//прочитаем источники данных
			
			ЧтениеXML.Прочитать();
			
			Попытка 
				Если ВозможностьЧтенияXML(ЧтениеXML) Тогда
				    ИсточникДанных = ПрочитатьXML(ЧтениеXML);
					Если Найти(ИсточникДанных.Родитель, "<Объект не найден")>0 Тогда
						ИсточникДанных.Родитель=Неопределено;
					КонецЕсли;
    				ИсточникДанных.Записать();
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='  Источник данных: ';")+СокрЛП(ИсточникДанных));
					
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Чтение источника данных не возможно.';en='Reading the data source is not possible.'"));
					Возврат Неопределено;
					
				КонецЕсли;
				
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				Возврат Неопределено;
		
			КонецПопытки;
			               
		ИначеЕсли ИмяУзла="template_datafunction" Тогда
			//прочитаем параметры шаблона
			
			ЧтениеXML.Прочитать();
			
			Попытка 
				Если ВозможностьЧтенияXML(ЧтениеXML) Тогда
				    ФункцияПолученияДанных = ПрочитатьXML(ЧтениеXML);
    				ФункцияПолученияДанных.Записать();
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='  Функция получения данных: ';")+СокрЛП(ФункцияПолученияДанных));
					
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Чтение функции получения данных не возможно.';en='Reading function data acquisition is not possible.'"));
					Возврат Неопределено;
					
				КонецЕсли;
				
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				Возврат Неопределено;
		
			КонецПопытки;
	
		ИначеЕсли ИмяУзла="template_params" Тогда
			//прочитаем параметры шаблона
			
			ЧтениеXML.Прочитать();
			
			Попытка 
				Если ВозможностьЧтенияXML(ЧтениеXML) Тогда
				    ПараметрШаблона = ПрочитатьXML(ЧтениеXML);
    				ПараметрШаблона.Записать();
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='  Параметр шаблона: ';")+СокрЛП(ПараметрШаблона));
					
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Чтение параметра шаблона не возможно.';en='Reading a template parameter is not possible.'"));
					Возврат Неопределено;
					
				КонецЕсли;
				
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				Возврат Неопределено;
		
			КонецПопытки;
						
		КонецЕсли;
			
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Загружен шаблон файла: ';")+СокрЛП(ЗагруженныйШаблонФайла));
	
	Если ЗагруженныйШаблонФайла=Неопределено Тогда
		Возврат Неопределено;
		
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Загрузка завершена.';en='Download Complete.'"));

	Возврат ЗагруженныйШаблонФайла.Ссылка;
	
КонецФункции

// Функция добавляет в конце слэш, если его нет
Процедура ДобавитьСлешЕслиНужно(НовыйПуть)
	Если Прав(НовыйПуть, 1) <> "\" И Прав(НовыйПуть,1) <> "/" Тогда
		НовыйПуть = НовыйПуть + "\";
	КонецЕсли;
КонецПроцедуры	

// Функция проверяет существование файлов документа
// Параметры:
// 	ВладелецФайла - Владелец файла
// Возвращаемое значение: Булево
Функция ФайлыДокументаСуществуют(ВладелецФайла) Экспорт
	Запрос=Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                    |	Файлы.Ссылка
	                    |ИЗ
	                    |	Справочник.Файлы КАК Файлы
	                    |ГДЕ
	                    |	Файлы.ВладелецФайла = &ВладелецФайла
	                    |	И Файлы.ПометкаУдаления = ЛОЖЬ");
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Если Выборка.Следующий() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Процедура выполняет мониторинг внешних каталогов
// Параметры:
// 	 Нет
Процедура МониторингВнешнихКаталогов() Экспорт
	ОбработатьФайловыеКаталоги();
	
КонецПроцедуры

// Процедура выполняет обработку файловых каталогов
// Параметры:
// 	 Нет
Процедура ОбработатьФайловыеКаталоги()
	
	Возврат;
	
КонецПроцедуры

// Функция проверяет существование файла
// Параметры:
// 	ПутьКФайлу- Путь к файлу
// Возвращаемое значение: Булево
Функция ФайлСуществует(ПутьКФайлу) Экспорт
	
	Файл=Новый Файл(ПутьКФайлу);
	
	Возврат Файл.Существует();
	
КонецФункции

#КонецОбласти
